import 'package:discuzq/widgets/ui/ui.dart';
import 'package:flutter/material.dart';

class DiscuzText extends StatelessWidget {
  const DiscuzText(this.text,
      {Key key,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.overflow,
      this.fontFamily,
      this.textAlign,
      this.primary = false,
      this.isGreyText = false,
      this.textScaleFactor})
      : super(key: key);

  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final double textScaleFactor;
  final String fontFamily;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final bool primary;

  final bool isGreyText;

  @override
  Widget build(BuildContext context) {
    Color _textColor = color ?? DiscuzApp.themeOf(context).textColor;
    if (isGreyText) {
      _textColor = DiscuzApp.themeOf(context).greyTextColor;
    }

    if (primary) {
      _textColor = DiscuzApp.themeOf(context).primaryColor;
    }

    return Text(
      text,
      textScaleFactor: textScaleFactor,
      overflow: overflow,
      textAlign: textAlign,
      style: TextStyle(
          color: _textColor,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
          fontSize: fontSize ?? DiscuzApp.themeOf(context).normalTextSize),
    );
  }
}
