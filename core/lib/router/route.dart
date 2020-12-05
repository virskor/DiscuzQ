import 'package:core/router/routers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'package:core/utils/authHelper.dart';
import 'package:core/widgets/ui/ui.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DiscuzRoute {
  static Future<bool> navigate({
    @required BuildContext context,

    ///
    /// fullscreenDialog
    /// 是否以对话框方式弹出
    bool fullscreenDialog = false,

    ///
    /// shouldLogin
    /// 是否需要登录，才能查看
    bool shouldLogin = false,

    ///
    /// PresentModal
    bool isModal = false,

    /// Path
    /// 使用Fluro路由时，传入Path
    final String path,

    /// 要加载的widget，当传入的path为空时生效
    Widget widget,
  }) async {
    ///
    /// 有的页面可能需要登录后才能查看
    if (shouldLogin == true) {
      try {
        final logined =
            await AuthHelper.requsetShouldLogin(context: context);
        if (!logined) {
          return Future.value(false);
        }
      } catch (e) {
        throw e;
      }
    }

    if (path != null) {
      /// 路由过度效果，默认使用native
      TransitionType transition = TransitionType.native;

      if (fullscreenDialog) {
        transition = TransitionType.cupertinoFullScreenDialog;
      }

      Routers.router.navigateTo(context, path, transition: transition);
      return Future.value(true);
    }

    if (isModal) {
      return showCupertinoModalBottomSheet(
          expand: true,
          backgroundColor: Colors.transparent,
          context: context,
          builder: (BuildContext context) => Theme(
                data: Theme.of(context).copyWith(
                    // This makes the visual density adapt to the platform that you run
                    // the app on. For desktop platforms, the controls will be smaller and
                    // closer together (more dense) than on mobile platforms.
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    primaryColor: DiscuzApp.themeOf(context).primaryColor,
                    backgroundColor: DiscuzApp.themeOf(context).backgroundColor,
                    scaffoldBackgroundColor:
                        DiscuzApp.themeOf(context).scaffoldBackgroundColor,
                    canvasColor:
                        DiscuzApp.themeOf(context).scaffoldBackgroundColor),
                child: CupertinoPageScaffold(
                  resizeToAvoidBottomInset: false,
                  child: widget,
                ),
              ));
    }

    return Navigator.of(context).push(CupertinoPageRoute(
        fullscreenDialog: fullscreenDialog,
        builder: (_) => Theme(
            data: Theme.of(context).copyWith(
                // This makes the visual density adapt to the platform that you run
                // the app on. For desktop platforms, the controls will be smaller and
                // closer together (more dense) than on mobile platforms.
                visualDensity: VisualDensity.adaptivePlatformDensity,
                primaryColor: DiscuzApp.themeOf(context).primaryColor,
                backgroundColor: DiscuzApp.themeOf(context).backgroundColor,
                scaffoldBackgroundColor:
                    DiscuzApp.themeOf(context).scaffoldBackgroundColor,
                canvasColor:
                    DiscuzApp.themeOf(context).scaffoldBackgroundColor),
            child: widget)));
  }
}
