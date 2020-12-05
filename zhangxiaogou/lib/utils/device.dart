import 'package:device_info/device_info.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_user_agent/flutter_user_agent.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FlutterDevice {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  /// 判断当前环境是release还是开发调试
  static const isDevelopment =
      const bool.fromEnvironment('dart.vm.product') == false;

  /// 判断当前是否是Web
  static const bool isWeb = kIsWeb;

  /// get webview useragent
  static Future<String> getWebviewUserAgent() async {
    String userAgent, webViewUserAgent;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
      await FlutterUserAgent.init();
      webViewUserAgent = FlutterUserAgent.webViewUserAgent;
    } on PlatformException {
      userAgent = webViewUserAgent = '<error>';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    return webViewUserAgent ?? userAgent;
  }

  /// getDeviceAgentString 获取设备标识符
  /// 现在还用不到的在DZ当中，不过我提前封装了
  static Future<String> getDeviceAgentString() async {
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return Future.value(
          "${Uri.encodeFull(androidInfo.brand)};${Uri.encodeFull(androidInfo.model)}");
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return Future.value(
          "${Uri.encodeFull(iosInfo.name)};${iosInfo.utsname.machine} ${iosInfo.systemVersion}");
    }
    return Future.value("unknown");
  }

  /// 设备震动
  /// 仅IOs
  ///
  static void emitVibration() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        HapticFeedback.lightImpact();
        break;
      case TargetPlatform.fuchsia:
        break;
      case TargetPlatform.android:
        break;
      default:
        break;
    }
  }
}
