import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'package:discuzq/views/settings/preferencesDelegate.dart';

/// 前期没有使用Router 后期会将页面逐渐全部完成由路由管理
class Routers {
  static FluroRouter router;

  /// 偏好设置
  static const String preferences = "/preferences";

  static void configureRoutes(FluroRouter router) {
    final Handler preferencesHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return const PreferencesDelegate();
    });

    router.define(preferences, handler: preferencesHandler);
  }
}
