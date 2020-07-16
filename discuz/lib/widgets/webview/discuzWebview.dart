import 'package:discuzq/widgets/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:discuzq/widgets/appbar/appbarExt.dart';

class DiscuzWebview extends StatefulWidget {
  ///
  /// 要打开的Url
  ///
  final String url;

  ///
  /// 预置标题
  ///
  final String title;

  const DiscuzWebview(this.url, {this.title = '浏览'});

  @override
  _DiscuzWebviewState createState() => _DiscuzWebviewState();
}

class _DiscuzWebviewState extends State<DiscuzWebview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DiscuzAppBar(
        title: widget.title,
      ),
      backgroundColor: DiscuzApp.themeOf(context).backgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
            child: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget.url,
              onWebViewCreated: (WebViewController webViewController) {
                /// webViewController.evaluateJavascript(_evaluateJS);
              },
              onPageFinished: (url) {},
            ),
          )
        ],
      ),
    );
  }
}
