import 'package:core/views/topics/appTopicsDelegate.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'package:core/views/settings/preferencesDelegate.dart';

/// 前期没有使用Router 后期会将页面逐渐全部完成由路由管理
class Routers {
  static FluroRouter router;

  /// 偏好设置
  static const String preferences = "/preferences";

  /// 话题列表
  static const String topics = "/topics";

  static void configureRoutes(FluroRouter router) {
    final Handler preferencesHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return const PreferencesDelegate();
    });

    /// 话题
    final Handler topicsHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return const AppTopicsDelegate();
    });

    router.define(preferences, handler: preferencesHandler);
    router.define(topics, handler: topicsHandler);
  }
}
