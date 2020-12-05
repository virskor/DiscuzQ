import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:core/widgets/captcha/tencentCloudCaptchaContainer.dart';
import 'package:core/models/captchaModel.dart';


///
/// 腾讯云 天御验证码Flutter组件封装
///
class TencentCloudCaptcha {
  ///
  ///
  /// 弹出验证码对话框
  /// callback中，会给出最终网页回调的信息，根据回调的信息判定是否成功获取randStr和票据
  /// 如果没有成功，需要用户获取
  ///
  /// 此外await show() 可以一直等待对话框关闭，进行阻塞
  static Future<CaptchaModel> show(
      {@required BuildContext context, @required String appID}) async {
    ///
    /// 用于捕捉回调的信息
    /// 初始化 null
    ///
    dynamic callbackData;

    ///
    /// 打开验证码用户操作组件
    await showCupertinoModalPopup(
        context: context,
        /// useRootNavigator: true,
        /// backgroundColor: Colors.transparent,
        /// TencentCloudCaptchaContainer wrapped by a Material widget so that you can use cupertino rendering
        builder: (BuildContext context) => TencentCloudCaptchaContainer(
              appID: appID,
              callback: (CaptchaModel data) {
                callbackData = data;
              },
            ));

    /// todo:
    ///
    /// 校验错误，
    /// 如果返回的信息是用户取消，那么return null

    return Future.value(callbackData);
  }
}
