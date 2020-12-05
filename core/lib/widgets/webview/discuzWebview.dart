import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:core/widgets/appbar/appbarExt.dart';
import 'package:core/utils/authorizationHelper.dart';
import 'package:core/widgets/ui/ui.dart';

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
  /*
   * loading process
   */
  double progress = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          progress < 1.0
              ? LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.transparent,
                  minHeight: 2,
                )
              : const SizedBox(),
          Expanded(
              child: InAppWebView(
            initialUrl: widget.url,
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(),
                ios: IOSInAppWebViewOptions(
                    allowsBackForwardNavigationGestures: false)),
            /*
            * Webview created
            */
            onWebViewCreated: (InAppWebViewController controller) async {
              _webView = controller;
              await _initWebviewJSBirdge();
            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              setState(() {
                this.progress = progress / 100;
              });
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
   * 初始化JS bridge
   * 仅在 isInteract 交互模式时支持，否则不支持，避免泄露重要数据
   */
  Future<void> _initWebviewJSBirdge() async {
    if (!widget.isInteract) {
      return;
    }

    try {
      await _webView.injectJavascriptFileFromAsset(
          assetFilePath: 'assets/js/bridge.js');
      await _webView.injectCSSFileFromAsset(assetFilePath: 'assets/css/h5.css');

      await _addHandlers();
    } catch (e) {
      print(e);
    }
  }

  /*
   * 添加JS交互逻辑
   */
  Future<void> _addHandlers() async {
    /*
     * 请求获取accessToken
     */
    _webView.addJavaScriptHandler(
        handlerName: 'getAccessToken',
        callback: (List<dynamic> arguments) async {
          final String authorization = await AuthorizationHelper().getToken();
          return authorization ?? '';
        });

    /*
     * 请求登录用户的信息
     */
    _webView.addJavaScriptHandler(
        handlerName: 'getCurrentUser',
        callback: (List<dynamic> arguments) async {
          try {
            final dynamic user = await AuthorizationHelper().getUser();
            if (user == null) {
              return '';
            }

            return user;
          } catch (e) {
            print(e);
            return '';
          }
        });
  }
}
