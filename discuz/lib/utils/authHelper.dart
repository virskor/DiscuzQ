import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:discuzq/models/userModel.dart';
import 'package:discuzq/utils/StringHelper.dart';
import 'package:discuzq/utils/authorizationHelper.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/states/appState.dart';
import 'package:discuzq/router/routeBuilder.dart';
import 'package:discuzq/views/users/loginDelegate.dart';

class AuthHelper {
  /// pop login delegate
  static login({BuildContext context}) =>
      Navigator.of(context).push(DiscuzCupertinoPageRoute(
          fullscreenDialog: true,
          builder: (_) {
            return const LoginDelegate();
          }));

  /// requst login dialog and waiting for login result
  static Future<bool> requsetShouldLogin(
      {BuildContext context, AppState state}) async {
    bool success = false;

    ///
    /// 如果已经登录了直接返回 true
    /// 不要再次弹出登录对话框
    ///
    if (state.user != null) {
      return Future.value(true);
    }

    final LoginDelegate authentication = LoginDelegate(
      onRequested: (bool val) {
        success = val;
      },
    );

    await showCupertinoModalPopup(
        context: context,
        builder: (_) {
          return authentication;
        });

    return Future.value(success);
  }

  /// 处理用户请求退出登录
  static Future<void> logout({@required AppState state}) async {
    await AuthorizationHelper().clearAll();
    state.updateUser(null);
  }

  ///
  /// 刷新用户信息
  /// 这意味着当前登录的用户信息，将被刷新
  /// 用户信息不回存到本地，只会被刷新成APP状态
  /// 其实没有必要保存到本地，本地的仅需要登录时保存就可以了，因为用户信息刷新的逻辑其实很多的
  ///
  static Future<bool> refreshUser(
      {@required BuildContext context,
      @required AppState state,
      UserModel data}) async {
    /// 有时候可能有的接口有反馈，这个时候直接用接口查询过来的数据更新
    /// 这样就避免了自己去查
    /// 其实这种方式虽然简单，但有问题
    /// todo: 最后还是要自己建立一些数据模型，来转化，防止前端出现一些难以维护的异常
    if (data != null) {
      state.updateUser(data);
      return Future.value(true);
    }

    final String urlDataUrl = "${Urls.users}/${state.user.id}";
    Response resp = await Request(context: context).getUrl(url: urlDataUrl);

    if (resp == null) {
      return Future.value(false);
    }

    state.updateUser(UserModel.fromMap(maps: resp.data['data']['attributes']));
    return Future.value(true);
  }

  ///
  /// 从本地读取已存的用户信息
  /// 从本地获取，如果用户没有登录的情况下会为null， 但是无关紧要
  ///
  static Future<void> getUserFromLocal({@required AppState state}) async {
    try {
      final dynamic user = await AuthorizationHelper().getUser();
      if(user == null){
        return;
      }
      state.updateUser(UserModel.fromMap(maps: jsonDecode(user)));
    } catch (e) {
      print(e);
    }
  }

  ///
  /// Magic! let a dynamic data transform into app state
  /// Process login and register request
  ///
  static Future<void> processLoginByResponseData(dynamic response,
      {@required AppState state}) async {
    ///
    /// 读取accessToken
    ///
    final String accessToken = response['data']['attributes']['access_token'];
    if (StringHelper.isEmpty(string: accessToken) == true) {
      return Future.value(false);
    }

    ///
    /// 读取refreshToken
    ///
    final String refreshToken = response['data']['attributes']['refresh_token'];
    if (StringHelper.isEmpty(string: accessToken) == true) {
      return Future.value(false);
    }

    ///
    /// 读取用户信息
    ///
    final List<dynamic> included = response['included'];
    final dynamic user =
        included.where((it) => it['type'] == "users").toList()[0];

    ///
    /// 存储accessToken
    /// 先清除，在保存，否则保存会失败
    /// 调用clear只会清除一个项目，这样会导致用户切换信息错误
    /// 所以要清除token 和用户信息存储，在回调处理中在进行更新用户信息的Process提示
    /// 我不想写update逻辑，就这样简单粗暴无bug多完美？
    ///
    await AuthorizationHelper()
        .clear(key: AuthorizationHelper.authorizationKey);
    await AuthorizationHelper().clear(key: AuthorizationHelper.userKey);
    await AuthorizationHelper().clear(key: AuthorizationHelper.refreshTokenKey);

    /// 保存token
    await AuthorizationHelper()
        .save(data: jsonEncode(user['attributes']), key: AuthorizationHelper.userKey);
    await AuthorizationHelper()
        .save(data: accessToken, key: AuthorizationHelper.authorizationKey);
    await AuthorizationHelper()
        .save(data: refreshToken, key: AuthorizationHelper.refreshTokenKey);

    /// 更新用户状态
    state.updateUser(UserModel.fromMap(maps: user['attributes']));
  }
}
