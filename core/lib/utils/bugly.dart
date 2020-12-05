import 'dart:io';

import 'package:core/utils/device.dart';
import 'package:flutter_bugly/flutter_bugly.dart';

import 'package:core/utils/buildInfo.dart';

class BuglyResultInfo {
  final String message;
  final String appId;
  final bool isSuccess;

  BuglyResultInfo({this.message = "", this.appId = "", this.isSuccess = false});

  BuglyResultInfo.fromMap(dynamic map)
      : message = map.message,
        appId = map.appId,
        isSuccess = map.isSuccess;
}

class DiscuzBugly {
  /// 初始化
  static Future<BuglyResultInfo> init() async {

    if (BuildInfo().info().bugly == null) {
      return Future.value(
          BuglyResultInfo(message: "未配置", appId: "", isSuccess: false));
    }

    if (FlutterDevice.isDevelopment) {
      return Future.value(BuglyResultInfo(
          message: "开发环境不启用Bugly", appId: "", isSuccess: false));
    }
    

    final result = await FlutterBugly.init(
      androidAppId: BuildInfo().info().bugly['Android'],
      iOSAppId: BuildInfo().info().bugly['IOS'],
      // autoDownloadOnWifi: true,
      // autoCheckUpgrade: Platform.isAndroid,
      // showInterruptedStrategy: false,
      // canShowApkInfo: false
    );

    return Future.value(BuglyResultInfo.fromMap(result));
  }

  /// 结束
  static void dispose() => FlutterBugly.dispose();

  static Stream<UpgradeInfo> onCheckUpgrade = FlutterBugly.onCheckUpgrade;

  /// checkUpdate
  /// 如果用户手动点击更新，那么传入 isManual = true
  static Future<Null> checkUpdate({bool isManual = false}) async {
    /// 仅安卓下支持检测更新
    if (!Platform.isAndroid) {
      return null;
    }

    return FlutterBugly.checkUpgrade(isManual: isManual);
  }
}
