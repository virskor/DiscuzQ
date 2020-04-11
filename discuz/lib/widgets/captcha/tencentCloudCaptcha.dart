import 'package:flutter/material.dart';

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
  static Future<void> show(
      {BuildContext context, @required Function callback}) async {

      }
}
