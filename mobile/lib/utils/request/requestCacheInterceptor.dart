import 'dart:async';

import 'package:dio/dio.dart';


/// refresh 在请求时添加，来避免缓存
/// 但这个涉及到DZ后端优化才能成功，先添加后续clone DZQ时自己做钩子优化请求
class RequestCacheInterceptor extends Interceptor {
  RequestCacheInterceptor();

  var _cache = Map<Uri, Response>();

  @override
  Future onRequest(RequestOptions options) async {
    Response response = _cache[options.uri];
    if (options.extra["refresh"] == true) {
      print("${options.uri}: force refresh, ignore cache! \n");
      return options;
    } else if (response != null) {
      print("cache hit: ${options.uri} \n");
      return response;
    }
  }

  @override
  Future onResponse(Response response) async {
    _cache[response.request.uri] = response;
  }

  @override
  Future onError(DioError e) async {
    print('onError: $e');
  }
}