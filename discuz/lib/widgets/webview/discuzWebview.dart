import 'dart:async';
import 'package:discuzq/utils/authorizationHelper.dart';
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

  ///
  /// 是否是app和网站交互模式
  /// 交互模式下，APP会自动在webview同步accesstoken
  ///
  final bool isInteract;

  const DiscuzWebview(
    this.url, {
    this.title = '浏览',
    this.isInteract = true,
  });

  @override
  _DiscuzWebviewState createState() => _DiscuzWebviewState();
}

class _DiscuzWebviewState extends State<DiscuzWebview> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
  }

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
              onWebViewCreated: (WebViewController webViewController) async {
                _controller.complete(webViewController);
                await _initWebviewJSBirdge();
              },
              onWebResourceError: (error) => debugPrint(error.description),
              onPageFinished: (url) {},
            ),
          )
        ],
      ),
    );
  }

  /*
   * 初始化
   */
  Future<void> _initWebviewJSBirdge() async {
    if (!widget.isInteract) {
      return;
    }

    // final String authorization = await AuthorizationHelper().getToken();

    // final String result = await _controller.evaluateJavascript(
    //     'window.localstorage.setitem("access_token", "$authorization");');
  }
}
