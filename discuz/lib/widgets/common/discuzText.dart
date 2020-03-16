import 'package:discuzq/ui/ui.dart';
import 'package:flutter/material.dart';

class DiscuzText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;

  const DiscuzText(this.text, {Key key, this.color, this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color ?? DiscuzApp.themeOf(context).textColor,
          fontSize: fontSize ?? DiscuzApp.themeOf(context).normalTextSize),
    );
  }
}
