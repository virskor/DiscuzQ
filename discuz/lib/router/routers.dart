import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'package:discuzq/views/settings/preferencesDelegate.dart';

class Routers {
  static FluroRouter router;

  /// 最近浏览
  static const String preferences = "/preferences";

  static void configureRoutes(FluroRouter router) {
    final Handler preferencesHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return const PreferencesDelegate();
    });

    router.define(preferences, handler: preferencesHandler);
  }
}
