package com.ygmpkk.flutter_umplus;

import android.app.Activity;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Log;
import com.umeng.analytics.MobclickAgent;
import com.umeng.commonsdk.UMConfigure;
import com.umeng.commonsdk.statistics.common.DeviceConfig;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterUmplusPlugin */
public class FlutterUmplusPlugin implements MethodCallHandler {
  private Activity activity;

  private FlutterUmplusPlugin(Activity activity) { this.activity = activity; }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel =
        new MethodChannel(registrar.messenger(), "ygmpkk/flutter_umplus");
    channel.setMethodCallHandler(new FlutterUmplusPlugin(registrar.activity()));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("init")) {
      initSetup(call, result);
    } else if (call.method.equals("beginPageView")) {
      beginPageView(call, result);
    } else if (call.method.equals("endPageView")) {
      endPageView(call, result);
    } else if (call.method.equals("logPageView")) {
      logPageView(call, result);
    } else if (call.method.equals("event")) {
      event(call, result);
    } else {
      result.notImplemented();
    }
  }

    private static String getMetadata(Context context, String name) {
        try {
            ApplicationInfo appInfo = context.getPackageManager().getApplicationInfo(
                    context.getPackageName(), PackageManager.GET_META_DATA);
            if (appInfo.metaData != null) {
                return appInfo.metaData.getString(name);
            }
        } catch (PackageManager.NameNotFoundException e) {
        }

        return null;
    }



    private void initSetup(MethodCall call, Result result) {
    String appKey = (String)call.argument("key");
    String channel = (String)call.argument("channel");
    Boolean logEnable = (Boolean)call.argument("logEnable");
    Boolean encrypt = (Boolean)call.argument("encrypt");
    Boolean reportCrash = (Boolean)call.argument("reportCrash");

    Log.d("UM", "initSetup: " + appKey);
//    Log.d("UM", "channel: " +  getMetadata(activity, "INSTALL_CHANNEL"));

    UMConfigure.setLogEnabled(logEnable);
    UMConfigure.init(activity, appKey, channel, UMConfigure.DEVICE_TYPE_PHONE,
                     null);
    UMConfigure.setEncryptEnabled(encrypt);

    MobclickAgent.setSessionContinueMillis(30000L);
    MobclickAgent.setCatchUncaughtExceptions(reportCrash);

    if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
      // 大于等于4.4选用AUTO页面采集模式
      MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.AUTO);
    } else {
      MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.MANUAL);
    }


    result.success(true);
  }

  public void beginPageView(MethodCall call, Result result) {
    String name = (String)call.argument("name");
    Log.d("UM", "beginPageView: " + name);
    MobclickAgent.onPageStart(name);
    MobclickAgent.onResume(activity);
    result.success(null);
  }

  public void endPageView(MethodCall call, Result result) {
    String name = (String)call.argument("name");
    Log.d("UM", "endPageView: " + name);
    MobclickAgent.onPageEnd(name);
    MobclickAgent.onPause(activity);
    result.success(null);
  }

  public void logPageView(MethodCall call, Result result) {
    // MobclickAgent.onProfileSignIn((String)call.argument("name"));
    // Session间隔时长,单位是毫秒，默认Session间隔时间是30秒,一般情况下不用修改此值
//    Long seconds = Double.valueOf(call.argument("seconds")).longValue();
//    MobclickAgent.setSessionContinueMillis(seconds);
    result.success(null);
  }

  public void event(MethodCall call, Result result) {
    String name = (String)call.argument("name");
    String label = (String)call.argument("label");
    if (label == null) {
      MobclickAgent.onEvent(activity, name);
    } else {
      MobclickAgent.onEvent(activity, name, label);
    }
    result.success(null);
  }

  public static String[] getTestDeviceInfo(Context context) {
    String[] deviceInfo = new String[2];
    try {
      if (context != null) {
        deviceInfo[0] = DeviceConfig.getDeviceIdForGeneral(context);
        deviceInfo[1] = DeviceConfig.getMac(context);
        Log.d("UM", deviceInfo[0]);
        Log.d("UM", deviceInfo[1]);
      }
    } catch (Exception e) {
    }
    return deviceInfo;
  }
}
