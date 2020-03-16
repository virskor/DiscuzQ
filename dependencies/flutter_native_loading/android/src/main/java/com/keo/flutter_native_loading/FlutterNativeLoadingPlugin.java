package com.keo.flutter_native_loading;

import android.app.Activity;
import android.app.ProgressDialog;

import io.flutter.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterNativeLoadingPlugin */
public class FlutterNativeLoadingPlugin implements MethodCallHandler {
  private final Activity activity;
  ProgressDialog progressDialog;


  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {

    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_native_loading");
    channel.setMethodCallHandler(new FlutterNativeLoadingPlugin(registrar.activity()));
  }

  private FlutterNativeLoadingPlugin(Activity activity) {
    this.activity = activity;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("showLoading")) {
      
      showLoading();
    }  else if (call.method.equals("hideLoading")) {
      Log.i("HideLoading", "true");
      progressDialog.dismiss();
    }
    else {
      result.notImplemented();
    }
  }

  public void showLoading() {

    progressDialog = ProgressDialog.show(activity,null,null,true,false);
    progressDialog.setContentView(R.layout.progress_bar);
    progressDialog.show();
  }

}
