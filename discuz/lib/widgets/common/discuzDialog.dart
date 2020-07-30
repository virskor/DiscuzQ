import 'package:flutter/material.dart';
import 'package:flutter_native_dialog/flutter_native_dialog.dart';

class DiscuzDialog {
  static Future<void> confirm(
      {@required BuildContext context,
      @required String title,
      @required String message,
      bool destructive = true,
      @required Function onConfirm,
      String positiveButtonText = '确定',
      String negativeButtonText = '取消'}) async {
    // ios用原生
    final bool result = await FlutterNativeDialog.showConfirmDialog(
        title: title,
        message: message,
        positiveButtonText: positiveButtonText,
        negativeButtonText: negativeButtonText,
        destructive: destructive);
    if (result == true && onConfirm != null) {
      onConfirm();
    }
  }
}
