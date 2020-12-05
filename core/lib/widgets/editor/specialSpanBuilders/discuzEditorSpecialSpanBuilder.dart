import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';

import 'package:core/widgets/editor/specialSpanBuilders/DiscuzAtTextSpan.dart';
import 'package:core/widgets/editor/specialSpanBuilders/discuzEmojiTextSpan.dart';
// import 'package:core/widgets/editor/specialSpanBuilders/discuzItalicTextSpan.dart';
// import 'package:core/widgets/editor/specialSpanBuilders/discuzBoldTextSpan.dart';

class DiscuzEditorSpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  /// whether show background for @somebody
  final bool showAtBackground;

  ///
  /// buildContext
  ///
  final BuildContext context;

  DiscuzEditorSpecialTextSpanBuilder(
      {this.showAtBackground: false, this.context});

  @override
  TextSpan build(String data, {TextStyle textStyle, onTap}) {
    var textSpan = super.build(data, textStyle: textStyle, onTap: onTap);
    return textSpan;
  }

  @override
  SpecialText createSpecialText(String flag,
      {TextStyle textStyle, SpecialTextGestureTapCallback onTap, int index}) {
    if (flag == null || flag == "") return null;

    ///index is end index of start flag, so text start index should be index-(flag.length-1)
    if (isStart(flag, DiscuzAtTextSpan.flag)) {
      return DiscuzAtTextSpan(textStyle,
          start: index - (DiscuzAtTextSpan.flag.length - 1));
    }

    ///
    /// 处理表情渲染
    if (isStart(flag, DiscuzEmojiTextSpan.flag)) {
      return DiscuzEmojiTextSpan(textStyle,
          start: index - (DiscuzEmojiTextSpan.flag.length - 1));
    }

    // ///
    // /// 处理粗体渲染
    // if (isStart(flag, DiscuzBoldTextSpan.flag)) {
    //   return DiscuzBoldTextSpan(textStyle,
    //       start: index - (DiscuzBoldTextSpan.flag.length - 1));
    // }

    // ///
    // /// 处理斜体渲染
    // if (isStart(flag, DiscuzItalicTextSpan.flag)) {
    //   return DiscuzItalicTextSpan(textStyle,
    //       start: index - (DiscuzItalicTextSpan.flag.length - 1));
    // }

    return null;
  }
}
