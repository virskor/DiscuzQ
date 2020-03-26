import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WebviewHelper {

  ///
  /// 使用chrome，或者safari打开一个URL
  /// Url 为必填项
  /// 切记Url不能包含Unicode字符，否则会闪退的情况，请urlencode处理
  static Future<void> launchUrl({@required String url}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
