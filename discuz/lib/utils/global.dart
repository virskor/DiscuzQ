import 'package:flutter/material.dart';

class Global {
  ///
  /// appname
  /// 应用程式名称
  ///
  static const String appname = 'DiscuzQ';

  ///
  /// domain
  /// 服务端域名
  /// 注意： 不要在域名后面加 / 路劲符
  ///
  static const String domain = 'https://discuz.chat';

  ///
  /// theme
  static const Color primaryColor = Color(0xFF316598);

  /// 日间模式底色
  static const Color scaffoldBackgroundColorLight = Color(0xFFDEDEDE);

  /// 夜间模式底色
  static const Color scaffoldBackgroundColorDark = Color(0xFF111111);

  /// 日间模式全局底色
  static const Color backgroundColorLight = Color(0xFFF9F9F9);

  /// 夜间模式全局底色
  static const Color backgroundColorDark = Color(0xFF222222);

  /// 日间模式字体颜色
  static const Color textColorLight = Color(0xFF444444);

  /// 夜间模式字体颜色
  static const Color textColorDark = Color(0xFFF2F2F2);

  /// 日间模式subtitle字体颜色
  static const Color greyTextColorLight = Color(0xFFDEDEDE);

  /// 夜间模式字体颜色
  static const Color greyTextColorDark = Color(0xFF444444);

  /// 手势配置
  ///
  /// 抽屉手滑动作用域
  static const double drawerEdgeDragWidth = 40;


  /// 边
  static const BorderSide border =
      const BorderSide(width: .2, color: const Color(0x1F000000));

  /// 加密
  ///
  /// 在您用于发布时，请更新下面的信息，下面的信息将对本地sqlite存储或shared preferences进行简单加密
  /// 这个数据随便的，其实这种加密本身也是没有安全可言的，在本地，只是保存明文的话又太那啥了。
  static const String encryptKey = '58sw517e13e05accb62f28145d1b13ccd8';
  static const String encryptIV = '06549488ew505b715';
}
