import 'package:discuzq/router/route.dart';
import 'package:discuzq/views/topics/topicListDelegate.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/webview/webviewHelper.dart';
import 'package:discuzq/widgets/common/discuzCachedNetworkImage.dart';

///
/// 渲染HTML
class HtmlRender extends StatelessWidget {
  ///
  /// 用于渲染的html 字符串
  final String html;

  ///
  /// 处理表情渲染
  final emojiOp = BuildOp(
    onPieces: (meta, pieces) {
      final src = meta.domElement.attributes['src'];
      return pieces
        ..first?.block?.addWidget(WidgetSpan(
                child: DiscuzCachedNetworkImage(
              imageUrl: src,
              width: 20,
            )));
    },
  );

  HtmlRender({@required this.html});

  @override
  Widget build(BuildContext context) => HtmlWidget(html,
      bodyPadding: const EdgeInsets.all(0),
      tableCellPadding: const EdgeInsets.all(2),
      enableCaching: true,
      webView: false,
      webViewJs: false,
      hyperlinkColor: DiscuzApp.themeOf(context).primaryColor,
      textStyle: TextStyle(
          color: DiscuzApp.themeOf(context).textColor,
          fontSize: DiscuzApp.themeOf(context).normalTextSize),

      /// todo: 需要完成Uri parse的过程，如果是站内连接直接调用app组件呈现
      onTapUrl: (url) async => await WebviewHelper.launchUrl(url: url),

      /// onTapSharpUrl 点击话题
      onTapSharpUrl: (int topicID) => topicID == 0
          ? () => false
          : DiscuzRoute.open(
              context: context,
              widget: TopicListDelegate(
                topicID: topicID,
              )),

      /// 处理表情渲染
      builderCallback: (meta, e) {
        if (e.classes.contains('qq-emotion')) {
          return lazySet(null, buildOp: emojiOp);
        }

        return meta;
      });
}
