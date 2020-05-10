import 'package:discuzq/utils/buildInfo.dart';
import 'package:discuzq/utils/device.dart';
import 'package:flutter_umplus/flutter_umplus.dart';

///
/// 根据Build.yaml来启动第三方统计功能
/// APP启动统计
class Analysis {

  ///
  /// 启动Umeng统计
  static Future<bool> initUmengAnalysis() {
    ///
    /// web不使用移动统计进行统计
    if(Device.isWeb){
      return Future.value(false);
    }

    if(BuildInfo().info().umengAppkey.isEmpty){
      return Future.value(false);
    }

    return FlutterUmplus.init(
      BuildInfo().info().umengAppkey,
      channel: BuildInfo().info().umengChannel,
      reportCrash: BuildInfo().info().umengReportCrash,
      logEnable: BuildInfo().info().umengLogEnable,
      encrypt: BuildInfo().info().umengEncrypt,
    );
  }
}
