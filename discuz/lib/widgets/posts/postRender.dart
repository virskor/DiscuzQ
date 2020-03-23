import 'package:flutter/material.dart';
import 'package:discuzq/widgets/htmRender/htmlRender.dart';

///
/// todo: 长按复制回复
/// 渲染评论的组件
/// 会渲染HTML基础的，还有表情

class PostRender extends StatelessWidget {
  ///
  /// 用于显示的内容
  final String content;

  const PostRender({@required this.content});

  @override
  Widget build(BuildContext context) {
    ////
    /// 将内容渲染为richText, 渲染表情等
    return HtmlRender(
      html: content,
    );
  }
}
