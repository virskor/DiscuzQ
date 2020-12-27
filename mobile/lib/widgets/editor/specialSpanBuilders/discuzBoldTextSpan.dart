import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DiscuzBoldTextSpan extends SpecialText {
  static const String flag = "**";
  final int start;
  final BuildContext context;

  DiscuzBoldTextSpan(TextStyle textStyle, {this.start, this.context})
      : super(
          flag,
          "**",
          textStyle,
        );

  @override
  InlineSpan finishText() {
    TextStyle textStyle = this.textStyle?.copyWith(
          fontWeight: FontWeight.bold,
        );

    final String boldText = toString();

    return SpecialTextSpan(
        text: boldText,
        actualText: boldText,
        start: start,
        style: textStyle,
        deleteAll: true,
        recognizer: (TapGestureRecognizer()
          ..onTap = () {
            /// do something
          }));
  }
}
