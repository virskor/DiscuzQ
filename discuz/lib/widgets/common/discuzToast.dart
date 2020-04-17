import 'package:discuzq/utils/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_wechat_toast/flutter_wechat_toast.dart';
import 'package:flutter_native_loading/flutter_native_loading.dart';

class DiscuzToast {
  static show({@required BuildContext context, String message = 'Toast'}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 2,
        backgroundColor: Colors.black.withOpacity(.88),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static success(
      {@required BuildContext context,
      String message = 'Toast',
      bool mask = true}) async {
    await WechatToast(context: context, mask: mask).success(message: message);
  }

  static Future<bool> failed(
      {BuildContext context, String message, bool mask = true}) async {
    /// 报错的时候在Request中，我们为了不每次请求都携带context,使用原生的toast进行提示。
    /// 但在UI操作的过程中，依旧保留使用Flutter相关toast组件
    if (context != null) {
      await WechatToast(context: context, mask: mask).failed(
          message: message, icon: Icon(SFSymbols.multiply_circle_fill, color: Colors.white, size: 35));
      return Future.value(true);
    }

    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 2,
        backgroundColor: Colors.black.withOpacity(.88),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static Function loading({BuildContext context, String message}) {
    if(Device.isWeb){
      return () => null;
    }
    ///
    ///  ios下使用原生组件
    ///
    FlutterNativeLoading.show();
    return FlutterNativeLoading.hide;
  }
}
