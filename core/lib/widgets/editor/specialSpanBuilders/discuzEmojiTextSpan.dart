import 'package:core/widgets/emoji/emoji.dart';
import 'package:flutter/material.dart';
import 'package:extended_text_field/extended_text_field.dart';

class DiscuzEmojiTextSpan extends SpecialText {
  static const String flag = ":";
  final int start;

  DiscuzEmojiTextSpan(TextStyle textStyle, {this.start})
      : super(
          flag,
          ":",
          textStyle,
        );

  @override
  InlineSpan finishText() {
    final String emojiText = toString();

    return ImageSpan(Emoji.getBySpan(span: emojiText),
        imageWidth: 23,
        imageHeight: 23,
        actualText: emojiText,
        start: start,
        margin: EdgeInsets.only(left: 2.0, bottom: 0.0, right: 2.0));
  }
}
