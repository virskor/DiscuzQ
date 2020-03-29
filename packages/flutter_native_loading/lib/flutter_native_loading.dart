import 'dart:async';

import 'package:flutter/services.dart';

class FlutterNativeLoading {
  static const MethodChannel _channel =
      const MethodChannel('flutter_native_loading');

  static Future<void> show() async {
    await _channel.invokeMethod('showLoading');
  }

  static Future<void> hide() async {
    await _channel.invokeMethod('hideLoading');
  }
}
