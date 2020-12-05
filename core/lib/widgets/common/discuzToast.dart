import 'package:core/utils/device.dart';
import 'package:status_alert/status_alert.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_native_loading/flutter_native_loading.dart';

enum DiscuzToastType {
  ///
  /// toast success information
  success,

  ///
  /// toast failed information
  failed,

  ///
  /// toast info
  info
}

class DiscuzToast {
  static const double _kIconSize = 50;

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

  ///
  /// toast notifications
  /// type: notification type
  /// message: notice message
  static void toast(
      {@required BuildContext context,
      DiscuzToastType type = DiscuzToastType.success,
      String message = '',
      title}) async {
    IconConfiguration icon =
        IconConfiguration(icon: Icons.info, size: _kIconSize);

    /// show icon type
    switch (type) {
      case DiscuzToastType.failed:
        {
          icon = IconConfiguration(icon: Icons.error, size: _kIconSize);
        }
        break;

      case DiscuzToastType.info:
        {
          icon = IconConfiguration(icon: Icons.info, size: _kIconSize);
        }
        break;

      case DiscuzToastType.success:
        {
          icon = IconConfiguration(icon: Icons.done, size: _kIconSize);
        }
        break;

      default:
        {
          //statements;
        }
        break;
    }

    return StatusAlert.show(context,
        title: title ?? message,
        subtitle: title == null ? null : message,
        configuration: icon,
        margin: const EdgeInsets.all(10.0),
        blurPower: 10,
        padding: const EdgeInsets.all(0));
  }

  ///
  /// 失败提示
  /// 行为+结果 如 删除成功
  static Future<bool> failed(
      {BuildContext context, String message, bool mask = true}) async {
    /// 报错的时候在Request中，我们为了不每次请求都携带context,使用原生的toast进行提示。
    /// 但在UI操作的过程中，依旧保留使用Flutter相关toast组件
    if (context != null) {
      toast(message: message, context: context, type: DiscuzToastType.failed);
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

  ///
  /// 加载中
  /// 返回函数，用于关闭
  static Function loading({BuildContext context, String message}) {
    if (FlutterDevice.isWeb) {
      //return WechatToast(context: context, mask: true).loading();
      return () => null;
    }

    ///
    ///  ios下使用原生组件
    ///
    FlutterNativeLoading.show();
    return FlutterNativeLoading.hide;
  }
}
