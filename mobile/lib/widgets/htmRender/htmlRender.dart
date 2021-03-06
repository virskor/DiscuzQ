import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:discuzq/widgets/ui/ui.dart';
import 'package:discuzq/widgets/webview/webviewHelper.dart';
import 'package:discuzq/router/route.dart';
import 'package:discuzq/views/topics/topicDetailDelegate.dart';
import 'package:discuzq/widgets/users/userLinkDetector.dart';
import 'package:discuzq/widgets/common/discuzLink.dart';
import 'package:discuzq/widgets/common/discuzDialog.dart';

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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return HtmlWidget(widget.html,
        enableCaching: true,
        webView: false,
        webViewJs: false,
        hyperlinkColor: DiscuzApp.themeOf(context).primaryColor,
        textStyle: TextStyle(
            color: DiscuzApp.themeOf(context).textColor,
            fontSize: DiscuzApp.themeOf(context).normalTextSize),

        /// todo: 需要完成Uri parse的过程，如果是站内连接直接调用app组件呈现
        onTapUrl: (url) async {
      await showDialog(
          context: context,
          child: DiscuzDialog(
            title: "是否继续打开",
            message: "即将打开外部链接，如您无法确保安全性则可以取消。 \r\n${url}",
            isCancel: true,
            confirmContent: "继续",
            onConfirm: () async {
              await WebviewHelper.launchUrl(url: url);
            },
          ));
    },

        // /// onTapSharpUrl 点击话题
        // onTapTopic: (int topicID) => topicID == 0
        //     ? () => false
        //     : DiscuzRoute.navigate(
        //         context: context,
        //         widget: TopicDetailDelegate(
        //           topicID: topicID,
        //         )),

        // /// onTapUserAtUrl 用户点击@someone
        // onTapUser: (int uid) =>
        //     UserLinkDetector(context: context).showUser(uid: uid),

        /// 处理表情渲染
        customWidgetBuilder: (element) {
      if (element.localName == 'img' &&
          element.classes.contains('qq-emotion')) {
        /// 处理表情大小
        element.attributes['style'] =
            element.attributes['style'] + ';width:30px;';
      }

      /// 处理话题
      if (element.localName == 'span' &&
          element.id == "topic" &&
          element.attributes.containsKey('value')) {
        final value = element.attributes['value'];
        return DiscuzLink(
          label: element.innerHtml,
          onTap: () {
            final topicID = int.tryParse(value);
            topicID == 0
                ? () => false
                : DiscuzRoute.navigate(
                    context: context,
                    widget: TopicDetailDelegate(
                      topicID: topicID,
                    ));
          },
        );
      }

      /// 处理@用户
      if (element.localName == 'span' &&
          element.id == "member" &&
          element.attributes.containsKey('value')) {
        final value = element.attributes['value'];
        return DiscuzLink(
          label: element.innerHtml,
          onTap: () {
            final uid = int.tryParse(value);
            UserLinkDetector(context: context).showUser(uid: uid);
          },
        );
      }

      return null;
    });
  }
}
