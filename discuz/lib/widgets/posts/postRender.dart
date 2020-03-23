import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:flutter/material.dart';

///
/// todo: 长按复制回复
class PostRender extends StatelessWidget {
  ///
  /// 用于显示的内容
  final String content;

  PostRender({@required this.content});

  @override
  Widget build(BuildContext context) {

    ////
    /// 将内容渲染为richText, 渲染表情等
    return DiscuzText(
      content,
      overflow: TextOverflow.ellipsis,
    );
  }
}
