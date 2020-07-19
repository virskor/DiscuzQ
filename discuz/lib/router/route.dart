import 'package:discuzq/widgets/ui/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:discuzq/states/appState.dart';
import 'package:discuzq/states/scopedState.dart';
import 'package:discuzq/utils/authHelper.dart';

class DiscuzRoute {
  static Future<bool> open({
    @required BuildContext context,

    ///
    /// fullscreenDialog
    /// 是否以对话框方式弹出
    bool fullscreenDialog = false,

    ///
    /// maintainState
    /// maintainState 去除后，会防止widget tree重构，但既然不重构，那么一些页面的状态也将丢失，所以慎用
    bool maintainState = true,

    ///
    /// shouldLogin
    /// 是否需要登录，才能查看
    bool shouldLogin = false,
    @required Widget widget,
  }) async {
    ///
    /// 有的页面可能需要登录后才能查看
    if (shouldLogin == true) {
      try {
        final AppState state =
            ScopedStateModel.of<AppState>(context, rebuildOnChange: true);

        final logined =
            await AuthHelper.requsetShouldLogin(context: context, state: state);
        if (!logined) {
          return Future.value(false);
        }
      } catch (e) {
        throw e;
      }
    }

    return Navigator.of(context).push(CupertinoPageRoute(
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        builder: (_) => Theme(
            data: Theme.of(context).copyWith(
                // This makes the visual density adapt to the platform that you run
                // the app on. For desktop platforms, the controls will be smaller and
                // closer together (more dense) than on mobile platforms.
                visualDensity: VisualDensity.adaptivePlatformDensity,
                primaryColor: DiscuzApp.themeOf(context).primaryColor,
                splashColor: DiscuzApp.themeOf(context).splashColor,
                highlightColor: DiscuzApp.themeOf(context).highlightColor,
                backgroundColor: DiscuzApp.themeOf(context).backgroundColor,
                scaffoldBackgroundColor:
                    DiscuzApp.themeOf(context).scaffoldBackgroundColor,
                canvasColor:
                    DiscuzApp.themeOf(context).scaffoldBackgroundColor),
            child: widget)));
  }
}
