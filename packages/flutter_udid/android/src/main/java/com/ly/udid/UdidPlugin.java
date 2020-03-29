package com.ly.udid;

import android.os.Build;
import android.provider.Settings;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class UdidPlugin implements MethodCallHandler {
  private Registrar registrar;

  private UdidPlugin(Registrar registrar) {
    this.registrar = registrar;
  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "plugins.ly.com/udid");
    channel.setMethodCallHandler(new UdidPlugin(registrar));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("udid")) {
      result.success(getUniqueId());
    } else {
      result.notImplemented();
    }
  }

  // https://blog.csdn.net/sunsteam/article/details/73189268
  private String getUniqueId() {
    String androidID = Settings.Secure.getString(registrar.activity().getContentResolver(), Settings.Secure.ANDROID_ID);
    String id = androidID + Build.SERIAL;
    return md5(id);
  }

  private static String md5(String string) {
    byte[] hash;
    try {
      hash = MessageDigest.getInstance("MD5").digest(string.getBytes("UTF-8"));
    } catch (NoSuchAlgorithmException e) {
      throw new RuntimeException("Huh, MD5 should be supported?", e);
    } catch (UnsupportedEncodingException e) {
      throw new RuntimeException("Huh, UTF-8 should be supported?", e);
    }
    StringBuilder hex = new StringBuilder(hash.length * 2);
    for (byte b : hash) {
      if ((b & 0xFF) < 0x10)
        hex.append("0");
      hex.append(Integer.toHexString(b & 0xFF));
    }
    return hex.toString();
  }
}
