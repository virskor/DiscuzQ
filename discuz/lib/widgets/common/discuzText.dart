import 'package:discuzq/ui/ui.dart';
import 'package:flutter/material.dart';

class DiscuzText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final double textScaleFactor;
  final TextOverflow overflow;

  const DiscuzText(this.text,
      {Key key,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.overflow,
      this.textScaleFactor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textScaleFactor: textScaleFactor,
      overflow: overflow,
      style: TextStyle(
          color: color ?? DiscuzApp.themeOf(context).textColor,
          fontWeight: fontWeight,
          fontSize: fontSize ?? DiscuzApp.themeOf(context).normalTextSize),
    );
  }
}
