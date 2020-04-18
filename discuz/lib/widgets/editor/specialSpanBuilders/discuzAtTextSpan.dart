import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DiscuzAtTextSpan extends SpecialText {
  static const String flag = "@";
  final int start;

  DiscuzAtTextSpan(TextStyle textStyle, {this.start})
      : super(
          flag,
          " ",
          textStyle,
        );

  @override
  InlineSpan finishText() {
    TextStyle textStyle =
        this.textStyle?.copyWith(color: Colors.blue, fontSize: 16.0);

    final String atText = toString();

    return SpecialTextSpan(
        text: atText,
        actualText: atText,
        start: start,
        style: textStyle,
        recognizer: (TapGestureRecognizer()
          ..onTap = () {
            /// do something
          }));
  }
}
