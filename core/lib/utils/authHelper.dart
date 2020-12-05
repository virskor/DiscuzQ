import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:core/views/users/loginDelegate.dart';
import 'package:core/models/userModel.dart';
import 'package:core/utils/StringHelper.dart';
import 'package:core/utils/authorizationHelper.dart';
import 'package:core/utils/request/request.dart';
import 'package:core/utils/request/urls.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:core/providers/userProvider.dart';

import '../models/userModel.dart';

class AuthHelper {
  /// pop login delegate
  static login({BuildContext context}) => showCupertinoModalBottomSheet(
      expand: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) => CupertinoPageScaffold(
            resizeToAvoidBottomInset: false,
            child: const LoginDelegate(),
          ));

  /// requst login dialog and waiting for login result
  static Future<bool> requsetShouldLogin(
      {BuildContext context}) async {
    bool success = false;

    ///
    /// 如果已经登录了直接返回 true
    /// 不要再次弹出登录对话框
    ///
    if (context.read<UserProvider>().hadLogined) {
      return Future.value(true);
    }

    await showCupertinoModalBottomSheet(
        expand: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) => CupertinoPageScaffold(
              resizeToAvoidBottomInset: false,
              child: const LoginDelegate(),
            ));

    return Future.value(success);
  }

  /// 处理用户请求退出登录
  static Future<void> logout({@required BuildContext context}) async {
    await AuthorizationHelper().clearAll();
    context.read<UserProvider>().logout();
  }

  ///
  /// 刷新用户信息
  /// 这意味着当前登录的用户信息，将被刷新
  /// 用户信息不回存到本地，只会被刷新成APP状态
  /// 其实没有必要保存到本地，本地的仅需要登录时保存就可以了，因为用户信息刷新的逻辑其实很多的
  ///
  static Future<bool> refreshUser(
      {@required BuildContext context, UserModel data}) async {
    /// 有时候可能有的接口有反馈，这个时候直接用接口查询过来的数据更新
    /// 这样就避免了自己去查
    /// 其实这种方式虽然简单，但有问题
    /// todo: 最后还是要自己建立一些数据模型，来转化，防止前端出现一些难以维护的异常
    if (data != null) {
      context.read<UserProvider>().updateUser(data);
      return Future.value(true);
    }

    final String urlDataUrl =
        "${Urls.users}/${context.read<UserProvider>().user.attributes.id.toString()}";
    Response resp = await Request(context: context).getUrl(url: urlDataUrl);

    if (resp == null) {
      return Future.value(false);
    }

    context
        .read<UserProvider>()
        .updateUser(UserModel.fromMap(maps: resp.data['data']));
    return Future.value(true);
  }

  ///
  /// 从本地读取已存的用户信息
  /// 从本地获取，如果用户没有登录的情况下会为null， 但是无关紧要
  ///
  static Future<void> getUserFromLocal({@required BuildContext context}) async {
    try {
      final dynamic user = await AuthorizationHelper().getUser();
      if (user == null) {
        return;
      }
      
      context
          .read<UserProvider>()
          .updateUser(UserModel.fromMap(maps: user));
    } catch (e) {
      throw e;
    }
  }

  ///
  /// Magic! let a dynamic data transform into app state
  /// Process login and register request
  ///
  static Future<void> processLoginByResponseData(dynamic response,
      {@required BuildContext context}) async {
    
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
        included.firstWhere((it) => it['type'] == "users");

    ///
    /// 存储accessToken
    /// 先清除，在保存，否则保存会失败
    /// 调用clear只会清除一个项目，这样会导致用户切换信息错误
    /// 所以要清除token 和用户信息存储，在回调处理中在进行更新用户信息的Process提示
    /// 我不想写update逻辑，就这样简单粗暴无bug多完美？
    ///
    await AuthorizationHelper()
        .clear();

    /// 保存token
    await AuthorizationHelper()
        .save(data: user, key: AuthorizationHelper.userKey);
    await AuthorizationHelper()
        .save(data: accessToken, key: AuthorizationHelper.authorizationKey);
    await AuthorizationHelper()
        .save(data: refreshToken, key: AuthorizationHelper.refreshTokenKey);

    /// 更新用户状态
    context.read<UserProvider>().updateUser(UserModel.fromMap(maps: user));
  }
}
