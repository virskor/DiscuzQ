import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:discuzq/widgets/appbar/appbarExt.dart';
import 'package:discuzq/utils/authorizationHelper.dart';
import 'package:discuzq/widgets/ui/ui.dart';

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
  InAppWebViewController _webView;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DiscuzAppBar(
        title: widget.title,
        brightness: Brightness.light,
      ),
      backgroundColor: DiscuzApp.themeOf(context).backgroundColor,
      body: Column(
        children: [
          Expanded(
              child: InAppWebView(
            initialUrl: widget.url,
            initialOptions:
                InAppWebViewGroupOptions(crossPlatform: InAppWebViewOptions()),
            /*
            * Webview created
            */
            onWebViewCreated: (InAppWebViewController controller) {
              _webView = controller;
              _initWebviewJSBirdge();
            },
            /*
             * webview 调试信息
             */
            onConsoleMessage: (controller, consoleMessage) =>
                print(consoleMessage),
          ))
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

    try {
      final String authorization = await AuthorizationHelper().getToken();
      await _webView.webStorage.localStorage
          .setItem(key: 'access_token', value: authorization);

      // await _webView.evaluateJavascript(source: '''
      //         document.ready = function(){
      //           document.querySelector(".content").style.padding = 0;
      //           document.querySelector(".qui-back").style.display = "none";
      //         }
      //         ''');
    } catch (e) {
      print(e);
    }
  }
}
