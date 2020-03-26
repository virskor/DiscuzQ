import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:discuzq/ui/ui.dart';
import 'package:discuzq/widgets/webview/webviewHelper.dart';

///
/// 渲染HTML
class HtmlRender extends StatelessWidget {
  ///
  /// 用于渲染的html 字符串
  final String html;

  ///
  /// 至于渲染的HTML内容之前的Widgets
  final List<Widget> prefixsChild;

  ///
  /// 处理表情渲染
  final emojiOp = BuildOp(
    onPieces: (meta, pieces) {
      final src = meta.domElement.attributes['src'];
      return pieces
        ..first?.block?.addWidget(WidgetSpan(
                child: CachedNetworkImage(
              imageUrl: src,
              width: 20,
            )));
    },
  );

  HtmlRender({@required this.html, this.prefixsChild});

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
      onTapUrl: (url) async =>
          await WebviewHelper.launchUrl(url: url),

      /// 处理表情渲染
      builderCallback: (meta, e) {
        if (e.classes.contains('qq-emotion')) {
          return lazySet(null, buildOp: emojiOp);
        }

        return meta;
      });
}
