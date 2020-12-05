import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:core/utils/debouncer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:core/utils/StringHelper.dart';
import 'package:core/widgets/common/discuzToast.dart';
import 'package:core/utils/authorizationHelper.dart';
import 'package:core/utils/device.dart';
import 'package:core/utils/request/urls.dart';
import 'package:core/utils/request/RequestCacheInterceptor.dart';
import 'package:core/utils/authHelper.dart';
import 'package:core/utils/request/requestErrors.dart';
import 'package:core/utils/request/requestFormer.dart';
import 'package:core/utils/buildInfo.dart';
import 'package:core/utils/global.dart';

const _contentFormData = "multipart/form-data";

class Request {
  final Dio _dio = Dio();
  final BuildContext context;
  final Debouncer _debouncer = Debouncer(milliseconds: 1000);

  /// 是否自动添加 票据
  final bool autoAuthorization;

  Request({this.context, this.autoAuthorization = true}) {
    ///
    /// HTTP Default ConnectionManager
    /// Verify Cert
    /// DefaultHttpClientAdapter 不要在web下添加
    /// web下browser会自动托管HTTP请求
    if (!FlutterDevice.isWeb) {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) =>
                BuildInfo().info().onBadCertificate;
      };
    }

    ///
    /// HTTP2支持
    /// 请在在build.yaml中进行相关的配置
    ///
    if (BuildInfo().info().enableHttp2) {
      _dio.httpClientAdapter = Http2Adapter(
        ConnectionManager(
          idleTimeout: BuildInfo().info().idleTimeout,

          /// Ignore bad certificate
          onClientCreate: (_, clientSetting) => clientSetting.onBadCertificate =
              (_) => BuildInfo().info().onBadCertificate,
        ),
      );
    }

    ///
    /// automatically decode json to dynamic
    _dio.transformer = RequestFormer(); // replace dio default transformer

    ///
    /// dio interceptors ext
    ///
    _dio.interceptors

      /// 请求时携带cookies
      ..add(CookieManager(CookieJar()))

      /// 请求缓存优化
      ..add(RequestCacheInterceptor())

      /// interceptor procedure
      ..add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
        final String authorization = await AuthorizationHelper().getToken();

        ///
        /// web下不调用原生API
        if (!FlutterDevice.isWeb) {
          final String deviceAgent = await FlutterDevice.getDeviceAgentString();
          final String userAgent = await FlutterDevice.getWebviewUserAgent();
          options.headers['user-agent'] = userAgent;
          options.headers['user-device'] =
              deviceAgent.split(';')[0]; // not important
        }

        // more devices
        options.connectTimeout = (1000 * 20);
        options.receiveTimeout = (1000 * 20);
        options.headers['client-type'] = 'app'; // not important
        if (!FlutterDevice.isWeb) {
          options.headers['referer'] = Global.domain;
        }

        if (authorization != null && autoAuthorization) {
          options.headers['authorization'] = "Bearer $authorization";
        }

        options.responseType = ResponseType.json;
        options.contentType = Headers.jsonContentType;
        options.headers['origin'] = Global.domain;

        ///
        /// http2 开启的时候，要将header中包含大写字符的Key 更改为小写
        /// 这是Flutter的BUG
        /// 否则 将收到错误
        /// onError: DioError [DioErrorType.DEFAULT]:
        /// HTTP/2 error: Stream error: Stream was terminated by peer (errorCode: 1).
        /// todo: 跟踪BUG
        // options.headers = options.headers
        //     .map((k, v) => MapEntry<String, dynamic>(k.toLowerCase(), v));

        ///
        ///

        /// RestFul APi 处理错误
        options.validateStatus = (int status) {
          return status >= 200 && status < 300 || status == 304;
        };

        return options;
      }, onResponse: (Response response) {
        /// on dio response
        return response;
      }, onError: (DioError e) async {
        // todo: this method should be removed after DIO fixed bugs some how
        e.response.data = await _temporaryTransformer(e.response.data);

        if (e.type == DioErrorType.DEFAULT) {
          DiscuzToast.failed(context: context, message: "网络故障");
          return e;
        }

        if (e.type == DioErrorType.CONNECT_TIMEOUT) {
          DiscuzToast.failed(context: context, message: '请求超时');
          return e;
        }

        if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
          DiscuzToast.failed(context: context, message: '响应超时');
          return e;
        }

        ///
        /// 处理http status code非正常错误
        ///
        if (e.response.statusCode == 401) {
          ///
          /// todo:
          /// 401的时候先校验错误信息是不是token过期，因为有时候站点关闭也是401。。。。
          ///
          ///
          /// 尝试自动刷新token，如果刷新token成功，继续上次请求
          debugPrint("------------Token 自动刷新开始-----------");
          try {
            final bool refreshResult = await _refreshToken();
            if (refreshResult == true) {
              /// 继续上次请求 Get
              if (e.request.method == "GET") {
                return await getUrl(
                    url: e.request.uri.toString(),
                    queryParameters: e.request.queryParameters);
              }

              /// 继续上次请求 Get
              if (e.request.method == "PATCH") {
                return await patch(
                    url: e.request.uri.toString(),
                    queryParameters: e.request.queryParameters);
              }

              ///
              if (e.request.method == "DELETE") {
                return await delete(
                    url: e.request.uri.toString(),
                    queryParameters: e.request.queryParameters);
              }

              /// 继续上次请求 Post Json
              if (e.request.method == "POST" &&
                  e.request.contentType == ContentType.json.toString()) {
                return await postJson(
                    url: e.request.uri.toString(),
                    data: e.request.data,
                    queryParameters: e.request.queryParameters);
              }

              /// 继续上次文件上传
              if (e.request.method == "POST" &&
                  e.request.contentType == _contentFormData) {
                return await uploadFile(
                    url: e.request.uri.toString(),
                    data: e.request.data,
                    queryParameters: e.request.queryParameters);
              }

              debugPrint("------------Token 自动刷新继续请求完成----------");
              return e;
            }

            debugPrint("------------Token 自动刷新失败----------");
          } catch (e) {
            // throw e;
          }

          /// 弹出登录
          if (autoAuthorization) {
            _popLogin();
          }

          ///
          /// 提醒用户接口返回的错误信息
          ///
          String errMessage = e.response.data['errors'] == null
              ? '未知错误'
              : RequestErrors.mapError(e.response.data['errors'][0]['code'],
                  err: e.response.data['errors'][0]);

          ///
          /// 401时，提醒用户错误信息
          DiscuzToast.failed(context: context, message: errMessage);
          return e;
        }

        ///
        /// 提醒用户接口返回的错误信息
        ///
        String errMessage = e.response.data['errors'] == null
            ? '未知错误'
            : RequestErrors.mapError(e.response.data['errors'][0]['code'],
                err: e.response.data['errors'][0]);

        ///
        /// 没有传入context,使用原生的toast组件进行提示
        ///
        DiscuzToast.show(context: context, message: errMessage);
        return e;
      }))

      /// logger
      ..add(PrettyDioLogger(
          requestHeader: false,
          requestBody: false,
          responseBody: false,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90));
  }

  ///
  /// automaitically refreshToken
  /// token刷新失败，如果有context则提示用户重新登录并弹出登录框
  ///
  Future<bool> _refreshToken() async {
    final String refreshToken = await AuthorizationHelper()
        .getToken(key: AuthorizationHelper.refreshTokenKey);

    /// 检测 refreshToken 不能为空，如果是空的，则返回失败并提示用户登录
    if (StringHelper.isEmpty(string: refreshToken)) {
      return Future.value(false);
    }

    /// 开始交换Token，如果token交换失败，也要提醒用户重新登录
    /// 请求时自动补全 RefreshToken
    try {
      final Dio dio = Dio();
      Response resp = await dio.post(Urls.usersRefreshToken, data: {
        "data": {
          "attributes": {
            "grant_type": "refresh_token",
            "refresh_token": refreshToken,
            "client_id": 2
          }
        }
      });

      if (resp.data['code'] == 200) {
        /// Toke 刷新成功，进行本地存储更新
        final String accessToken =
            resp.data['data']['attributes']['access_token'];
        final String refreshToken =
            resp.data['data']['attributes']['refresh_token'];
        if (StringHelper.isEmpty(string: accessToken) == true) {
          return Future.value(false);
        }
        await AuthorizationHelper()
            .clear();
        await AuthorizationHelper()
            .save(data: accessToken, key: AuthorizationHelper.authorizationKey);
        await AuthorizationHelper()
            .save(data: refreshToken, key: AuthorizationHelper.refreshTokenKey);
        return Future.value(true);
      }
    } catch (e) {
      final DioError err = e;
      throw err.response.data;
    }

    return Future.value(false);
  }

  ///
  /// pop login
  ///
  void _popLogin() {
    try {
      if (context != null) {
        _debouncer.run(() {
          AuthHelper.login(context: context);
        });
      }
    } catch (e) {
      throw e;
    }
  }

  ///
  /// GET
  ///
  Future<Response> getUrl(
      {@required String url, dynamic queryParameters}) async {
    Response resp;
    try {
      resp = await _dio.get(
        url,
        queryParameters: queryParameters,
      );
      // todo: this method should be removed after DIO fixed bugs some how
      resp.data = await _temporaryTransformer(resp.data);
    } catch (e) {
      throw e;
    }
    return Future.value(resp);
  }

  ///
  /// POST JSON
  ///
  Future<Response> postJson(
      {@required String url,
      dynamic data,
      dynamic queryParameters,
      Function onReceiveProgress,
      Function onSendProgress}) async {
    Response resp;

    try {
      resp = await _dio.post(url,
          data: data,
          queryParameters: queryParameters,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress);
      // todo: this method should be removed after DIO fixed bugs some how
      resp.data = await _temporaryTransformer(resp.data);
    } catch (e) {
      throw e;
    }

    return Future.value(resp);
  }

  ///
  /// DELETE
  ///
  Future<Response> delete({
    @required String url,
    dynamic data,
    dynamic queryParameters,
    CancelToken cancelToken,
  }) async {
    Response resp;

    try {
      resp = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      // todo: this method should be removed after DIO fixed bugs some how
      resp.data = await _temporaryTransformer(resp.data);
    } catch (e) {
      throw e;
    }

    return Future.value(resp);
  }

  ///
  /// PATCH
  ///
  Future<Response> patch({
    @required String url,
    dynamic data,
    dynamic queryParameters,
    CancelToken cancelToken,
  }) async {
    Response resp;

    try {
      resp = await _dio.patch(
        url,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      // todo: this method should be removed after DIO fixed bugs some how
      resp.data = await _temporaryTransformer(resp.data);
    } catch (e) {
      throw e;
    }

    return Future.value(resp);
  }

  ///
  /// upload files
  /// MultipartFile.fromFileSync("./example/upload.txt",
  ///        filename: "upload.txt"),
  ///
  Future<Response> uploadFile(
      {@required String url,
      dynamic data,
      String name = 'file',
      MultipartFile file,
      dynamic queryParameters,
      Function onReceiveProgress,
      Function onSendProgress}) async {
    Response resp;

    final FormData formData = data == null
        ? FormData.fromMap({name: file})
        : FormData.fromMap({name: file, ...data});

    try {
      resp = await _dio.post(url,
          data: formData,
          queryParameters: queryParameters,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          options: Options(contentType: _contentFormData));

      resp.data = await _temporaryTransformer(resp.data);

      return Future.value(resp);
    } catch (e) {
      throw e;
    }
  }

  /// 这是一个临时用的transformer
  /// 原因是因为DIO仅对 application/json生效，并且是写死的！但是DZ的是 application/vnd.api+json
  /// 所以这个方法用来重新decodejson， 后续将被移除
  /// todo: remove
  Future<dynamic> _temporaryTransformer(dynamic data) async {
    if (data.runtimeType != String) {
      return Future.value(data);
    }

    if (data == null) {
      Future.value(null);
    }

    return await compute(decodeData, data);
  }
}

///
/// 将json转化为dynamic
/// 事实上dio会自动转换，application/json
/// 但是由于dzq不是 application/json 的相应，DIO有不能自定义,所以暂时要自己转,这个蛮坑的
///
dynamic decodeData(dynamic data) {
  return json.decode(data);
}
