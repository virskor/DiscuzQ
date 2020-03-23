import 'package:cached_network_image/cached_network_image.dart';
import 'package:discuzq/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class HtmlRender extends StatelessWidget {
  final String html;

  HtmlRender({@required this.html});

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

  @override
  Widget build(BuildContext context) => RepaintBoundary(
        child: HtmlWidget(
          html,
          bodyPadding: const EdgeInsets.all(0),
          tableCellPadding: const EdgeInsets.all(2),
          enableCaching: true,
          webView: false,
          webViewJs: false,
          hyperlinkColor: DiscuzApp.themeOf(context).primaryColor,
          textStyle: TextStyle(
              color: DiscuzApp.themeOf(context).textColor,
              fontSize: DiscuzApp.themeOf(context).normalTextSize),
          onTapUrl: (url) => showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('onTapUrl'),
              content: Text(url),
            ),
          ),

          /// 处理表情渲染
          builderCallback: (meta, e) => e.classes.contains('qq-emotion')
              ? lazySet(null, buildOp: emojiOp)
              : meta,
        ),
      );
}
