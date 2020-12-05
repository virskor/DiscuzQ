import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:core/widgets/ui/ui.dart';
import 'package:core/widgets/webview/webviewHelper.dart';
import 'package:core/widgets/common/discuzCachedNetworkImage.dart';
import 'package:core/router/route.dart';
import 'package:core/views/topics/topicDetailDelegate.dart';
import 'package:core/widgets/users/userLinkDetector.dart';

class HtmlRender extends StatefulWidget {
  HtmlRender({@required this.html});

  ///
  /// 用于渲染的html 字符串
  final String html;

  @override
  _HtmlRenderState createState() => _HtmlRenderState();
}

class _HtmlRenderState extends State<HtmlRender>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return HtmlWidget(widget.html,
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
            : DiscuzRoute.navigate(
                context: context,
                widget: TopicDetailDelegate(
                  topicID: topicID,
                )),

        /// onTapUserAtUrl 用户点击@someone
        onTapUserAtUrl: (uid) =>
            UserLinkDetector(context: context).showUser(uid: uid),

        /// 处理表情渲染
        builderCallback: (meta, e) {
          if (e.classes.contains('qq-emotion')) {
            return lazySet(null, buildOp: emojiOp);
          }

          return meta;
        });
  }
}
