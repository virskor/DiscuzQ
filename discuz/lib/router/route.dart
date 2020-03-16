import 'package:flutter/material.dart';
import 'package:discuzq/router/routeBuilder.dart';

class DiscuzRoute {
  static Future<bool> open({
    @required BuildContext context,
    bool fullscreenDialog = false,
    bool maintainState = true,
    @required Widget widget,
  }) =>
      Navigator.of(context).push(DiscuzCupertinoPageRoute(
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          builder: (_) => widget));
}
