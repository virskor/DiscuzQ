import 'package:discuzq/utils/authorizationHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/models/appModel.dart';
import 'package:discuzq/router/routeBuilder.dart';
import 'package:discuzq/views/loginDelegate.dart';

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
      {BuildContext context, AppModel model}) async {
    bool success = false;

    ///
    /// 如果已经登录了直接返回 true
    /// 不要再次弹出登录对话框
    ///
    if (model.user != null) {
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
  Future<void> logout({AppModel model}) async {
    await AuthorizationHelper().clearAll();
    model.updateUser(null);
  }
}
