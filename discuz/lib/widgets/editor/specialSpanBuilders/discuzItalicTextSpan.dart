import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DiscuzItalicTextSpan extends SpecialText {
  static const String flag = "_";
  final int start;
  final BuildContext context;

  DiscuzItalicTextSpan(TextStyle textStyle, {this.start, this.context})
      : super(
          flag,
          "_",
          textStyle,
        );

  @override
  InlineSpan finishText() {
    TextStyle textStyle = this.textStyle?.copyWith(
          fontStyle: FontStyle.italic,
        );

    final String boldText = toString();

    return SpecialTextSpan(
        text: boldText,
        actualText: boldText,
        start: start,
        style: textStyle,
        recognizer: (TapGestureRecognizer()
          ..onTap = () {
            /// do something
          }));
  }
}
