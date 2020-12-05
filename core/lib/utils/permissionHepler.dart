import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:core/widgets/common/discuzToast.dart';

class PermissionHelper {
  ///
  /// 检查权限可用性
  static Future<bool> check(PermissionGroup group) async {
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(group);
    if (permission == PermissionStatus.granted ||
        permission == PermissionStatus.restricted) {
      return Future.value(true);
    }
    return Future.value(false);
  }

  ///
  /// 检查并提示用户
  /// 此操作会同时提示用户确认
  static Future<bool> checkWithNotice(PermissionGroup group,
      {BuildContext context}) async {
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(group);
    if (permission == PermissionStatus.granted ||
        permission == PermissionStatus.restricted) {
      return Future.value(true);
    }

    final requestResult = await requestePermission(<PermissionGroup>[group]);
    if (!requestResult) {
      DiscuzToast.show(context: context, message: '权限不足，请允许APP使用对应权限');
      return Future.value(false);
    }

    return Future.value(true);
  }

  ///
  /// 和用户请求权限
  static Future<bool> requestePermission(List<PermissionGroup> group) async {
    await PermissionHandler().requestPermissions(group);
    return Future.value(true);
  }

  ///打开设置
  static Future<bool> openSetting() {
    return PermissionHandler().openAppSettings();
  }
}
