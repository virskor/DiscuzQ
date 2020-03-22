import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:discuzq/widgets/common/discuzToast.dart';

class PermissionHelper {
  static Future<bool> check(PermissionGroup group) async {
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(group);
    if (permission == PermissionStatus.granted ||
        permission == PermissionStatus.restricted) {
      return Future.value(true);
    }
    return Future.value(false);
  }

  static Future<bool> checkWithNotice(PermissionGroup group,
      {BuildContext context}) async {
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(group);
    if (permission == PermissionStatus.granted ||
        permission == PermissionStatus.restricted) {
      return Future.value(true);
    }
    DiscuzToast.show(context: context, message: '权限不足，请允许APP使用对应权限');
    return Future.value(false);
  }

  static Future<bool> requesting(List<PermissionGroup> group) async {
    await PermissionHandler().requestPermissions(group);
    return Future.value(true);
  }

  static Future<bool> openSetting() {
    return PermissionHandler().openAppSettings();
  }
}
