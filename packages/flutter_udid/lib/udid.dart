import 'dart:async';

import 'package:flutter/services.dart';

class Udid {
  static const MethodChannel _channel =
      const MethodChannel('plugins.ly.com/udid');

  static Future<String> get udid async {
    final String version = await _channel.invokeMethod('udid');
    return version;
  }
}
