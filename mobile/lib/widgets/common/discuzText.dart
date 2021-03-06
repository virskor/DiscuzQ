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
      this.maxLines,
      this.isGreyText = false,
      this.isLargeText = false,
      this.isSmallText = false,
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
  final bool isLargeText;
  final bool isSmallText;
  final int maxLines;

  final bool isGreyText;

  @override
  Widget build(BuildContext context) {
    Color _textColor = color ?? DiscuzApp.themeOf(context).textColor;
    double _fontSize = fontSize ?? DiscuzApp.themeOf(context).normalTextSize;

    if (isGreyText) {
      _textColor = DiscuzApp.themeOf(context).greyTextColor;
    }

    if (isLargeText) {
      _fontSize = DiscuzApp.themeOf(context).largeTextSize;
    }

    if (isSmallText) {
      _fontSize = DiscuzApp.themeOf(context).smallTextSize;
    }

    if (primary) {
      _textColor = DiscuzApp.themeOf(context).primaryColor;
    }

    return Text(
      text,
      textScaleFactor: textScaleFactor,
      overflow: overflow,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
          color: _textColor,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
          letterSpacing: .89,
          wordSpacing: .66,
          fontSize: _fontSize),
    );
  }
}
