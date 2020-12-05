import 'package:flutter/material.dart';
import 'package:core/widgets/htmRender/htmlRender.dart';

///
/// todo: 长按复制回复
/// 渲染评论的组件
/// 会渲染HTML基础的，还有表情

class PostRender extends StatelessWidget {
  ///
  /// 用于显示的内容
  final String content;

  ///
  /// 至于渲染的HTML内容之前的Widgets
  final List<Widget> prefixsChild;

  const PostRender({@required this.content, this.prefixsChild = const []});

  @override
  ////
  /// 将内容渲染为richText, 渲染表情等
  /// todo，评论自动换行优化处理
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        mainAxisAlignment: MainAxisAlignment.start,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          ...prefixsChild,
          Flexible(
            flex:12,
            child: HtmlRender(
              html: content,
            ),
          )
        ],
      );
}
