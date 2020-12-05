import 'package:core/utils/global.dart';
import 'package:flutter/material.dart';

const DiscuzTheme _discuzTheme = DiscuzTheme();

class DiscuzApp extends InheritedWidget {
  final DiscuzTheme theme;

  DiscuzApp({Key key, this.theme, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(DiscuzApp oldWidget) {
    return true;
  }

  // themeOf context
  static DiscuzTheme themeOf(BuildContext context) {
    final DiscuzApp ui = DiscuzApp.of(context);
    if (ui == null) {
      return _discuzTheme;
    }

    return ui.theme == null ? _discuzTheme : ui.theme;
  }

  // of defined to get context binded for discuz app
  static DiscuzApp of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType(aspect: DiscuzApp);
  }
}

class DiscuzTheme {
  // primary theme color
  final Color primaryColor;
  //  backgroundColor
  final Color backgroundColor;
  // scaffoldBackgroundColor
  final Color scaffoldBackgroundColor;
  // text color default is Color(0xFF000000)
  final Color textColor;
  // grey text color default is Color(0xFF666666)
  final Color greyTextColor;
  // mini sized font width
  final double miniTextSize;
  // small sized font width
  final double smallTextSize;
  // normal sized font width
  final double normalTextSize;
  // medium sized font width
  final double mediumTextSize;
  // large sized font width
  final double largeTextSize;
  // global brightness
  final Brightness brightness;

  const DiscuzTheme(
      {this.backgroundColor = Global.backgroundColorLight,
      this.scaffoldBackgroundColor = Global.scaffoldBackgroundColorLight,
      this.primaryColor = Global.primaryColor,
      this.textColor = Global.textColorLight,
      this.greyTextColor = Global.greyTextColorLight,
      this.miniTextSize = 12,
      this.smallTextSize = 14,
      this.normalTextSize = 16,
      this.mediumTextSize = 18,
      this.largeTextSize = 22,
      this.brightness = Brightness.light});
}
