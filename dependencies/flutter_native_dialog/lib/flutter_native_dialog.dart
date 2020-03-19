import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

const MethodChannel _channel = const MethodChannel('flutter_native_dialog');

class FlutterNativeDialog {
  static const String DEFAULT_POSITIVE_BUTTON_TEXT = "OK";
  static const String DEFAULT_NEGATIVE_BUTTON_TEXT = "Cancel";

  /// Shows an alert dialog to the user
  ///
  /// An alert contains an optional [title], [message]. The [positiveButtonText]
  /// will appear under the dialog and allows users to close it. When closed,
  /// a bool will be returned to the user. This value will always be true.
  static Future<bool> showAlertDialog({
    String title,
    String message,
    String positiveButtonText,
  }) async {
    return await _channel.invokeMethod(
      'dialog.alert',
      {
        "title": title,
        "message": message,
        "positiveButtonText":
            positiveButtonText ?? DEFAULT_POSITIVE_BUTTON_TEXT,
      },
    );
  }

  /// Shows an alert dialog asking the user for a confirmation
  ///
  /// This alert contains an optional [title], [message]. [positiveButtonText]
  /// and [negativeButtonText] will be shown on the corresponding buttons. When
  /// the user clicks on [positiveButtonText] this will return true. When the
  /// user clicks on [negativeButtonText] this will return false. [destructive]
  /// can be set to true to show the user this is a destructive operation (only on iOS).
  static Future<bool> showConfirmDialog({
    String title,
    String message,
    String positiveButtonText = DEFAULT_POSITIVE_BUTTON_TEXT,
    String negativeButtonText = DEFAULT_NEGATIVE_BUTTON_TEXT,
    bool destructive = false,
  }) async {
    return await _channel.invokeMethod(
      'dialog.confirm',
      {
        "title": title,
        "message": message,
        "positiveButtonText": positiveButtonText,
        "negativeButtonText": negativeButtonText,
        "destructive": destructive,
      },
    );
  }

  @visibleForTesting
  static void setMockCallHandler(Future<dynamic> handler(MethodCall call)) {
    _channel.setMockMethodCallHandler(handler);
  }
}
