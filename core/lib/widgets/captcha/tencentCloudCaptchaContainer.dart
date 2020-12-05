import 'dart:async';
import 'dart:convert';

import 'package:core/models/captchaModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

///
/// 替换模板信息
/// replace index.html appid
/// 2099574797
///
const String _replacementTag = '{{APPID_REPLACEMENT}}';

///
/// 内置天御验证码用户操作交互的组件
/// 实际上是一个webview，使用js bridget进行了交互
/// https://pub.dev/packages/webview_flutter#-example-tab-
class TencentCloudCaptchaContainer extends StatefulWidget {
  ///
  /// 回调函数
  /// callback
  /// 回调函数中，会包含randSTR 票据，或者告知你用户取消了验证等
  final Function callback;

  ///
  /// 腾讯云验证码APPID
  ///
  final String appID;

  TencentCloudCaptchaContainer({this.callback, this.appID = ''});
  @override
  _TencentCloudCaptchaContainerState createState() =>
      _TencentCloudCaptchaContainerState();
}

class _TencentCloudCaptchaContainerState
    extends State<TencentCloudCaptchaContainer> {
  @override
  void setState(fn) {
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }

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
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        height: 400,
        margin: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: _buildWebview()),
      ),
    );
  }

  ///
  /// 创建webview容器
  /// 天御验证码，实际上使用webview进行渲染
  ///
  Widget _buildWebview() => Builder(
        builder: (context) {
          return WebView(
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              /// webViewController.evaluateJavascript(_evaluateJS);
              _loadHtmlFromAssets(webViewController);
            },
            onPageFinished: (url) {},
            javascriptChannels: <JavascriptChannel>[
              ///
              /// 监听
              _subscribeCaptchaCallbackChannel(context),
            ].toSet(),
          );
        },
      );

  ///
  /// 从本地加载HTML模板
  Future<void> _loadHtmlFromAssets(WebViewController controller) async {
    String fileText = await rootBundle.loadString('assets/captcha/index.html');

    ///
    /// 替换模板中的APPID
    ///
    fileText = fileText.replaceAll(_replacementTag, widget.appID);

    ///
    /// encode URI
    ///
    final String theURI = Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString();

    controller.loadUrl(theURI);
  }

  JavascriptChannel _subscribeCaptchaCallbackChannel(BuildContext context) =>
      JavascriptChannel(
          name: 'discuzCaptchaChannel',

          ///
          /// 处理js监听用户操作验证码回调的结果
          onMessageReceived: (JavascriptMessage msg) {
            final dynamic data = json.decode(msg.message);
            print(data);

            ///
            /// 如果用户点击关闭，其实也会收到事件，票据无效直接返回就好了
            if (data == null || data['randstr'] == '' || data['ticket'] == '') {
              widget.callback(null);
              Navigator.pop(context);
              return;
            }

            widget.callback(CaptchaModel.fromMap(maps: data));
            Navigator.pop(context);
          });
}
