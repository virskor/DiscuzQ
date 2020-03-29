package nl.wouterhardeman.flutternativedialog

import android.app.Activity
import android.app.AlertDialog
import android.os.Bundle
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class FlutterNativeDialogPlugin(val activity: Activity) : MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      if (registrar.activity() != null) {
        val channel = MethodChannel(registrar.messenger(), "flutter_native_dialog")
        channel.setMethodCallHandler(FlutterNativeDialogPlugin(registrar.activity()))
      }
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (!call.method.startsWith("dialog.")) {
      result.notImplemented()
      return
    }

    val dialogBuilder = AlertDialog.Builder(activity)

    if (call.method == "dialog.alert") {
      dialogBuilder.setMessage(call.argument<String>("message"))
        // if the dialog is cancelable
        .setCancelable(false)
        // positive button text and action
        .setPositiveButton(call.argument<String>("positiveButtonText")){ _, _ -> result.success(true) }
    }

    if (call.method == "dialog.confirm") {
      dialogBuilder.setMessage(call.argument<String>("message"))
        // if the dialog is cancelable
        .setCancelable(false)
        .setTitle(call.argument<String>("title"))
        // positive button text and action
        .setPositiveButton(call.argument<String>("positiveButtonText")){ _, _ -> result.success(true) }
        // negative button text and action
        .setNegativeButton(call.argument<String>("negativeButtonText")){ _, _ -> result.success(false) }
    }

    dialogBuilder.create().show()
  }
}
