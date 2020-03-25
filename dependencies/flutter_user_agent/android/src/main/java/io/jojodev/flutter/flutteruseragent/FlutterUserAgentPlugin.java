package io.jojodev.flutter.flutteruseragent;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Build.VERSION_CODES;
import android.webkit.WebSettings;
import android.webkit.WebView;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterUserAgentPlugin */
public class FlutterUserAgentPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_user_agent");
    channel.setMethodCallHandler(new FlutterUserAgentPlugin(registrar.context()));
  }

  private final Context context;
  private Map<String, Object> constants;

  private FlutterUserAgentPlugin(Context context) {
    this.context = context;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getProperties")) {
      result.success(getProperties());
    } else {
      result.notImplemented();
    }
  }

  private Map<String, Object> getProperties() {
    if(constants != null) {
      return constants;
    }
    constants = new HashMap<>();

    PackageManager packageManager = this.context.getPackageManager();
    String packageName = this.context.getPackageName();
    String shortPackageName = packageName.substring(packageName.lastIndexOf(".") + 1);
    String applicationName = "";
    String applicationVersion = "";
    int buildNumber = 0;
    String userAgent = this.getUserAgent();
    String packageUserAgent = userAgent;

    try {
      PackageInfo info = packageManager.getPackageInfo(packageName, 0);
      applicationName = this.context.getApplicationInfo().loadLabel(this.context.getPackageManager()).toString();
      applicationVersion = info.versionName;
      buildNumber = info.versionCode;
      packageUserAgent = shortPackageName + '/' + applicationVersion + '.' + buildNumber + ' ' + userAgent;

    } catch(PackageManager.NameNotFoundException e) {
      e.printStackTrace();
    }

    constants.put("systemName", "Android");
    constants.put("systemVersion", Build.VERSION.RELEASE);
    constants.put("packageName", packageName);
    constants.put("shortPackageName", shortPackageName);
    constants.put("applicationName", applicationName);
    constants.put("applicationVersion", applicationVersion);
    constants.put("applicationBuildNumber", buildNumber);
    constants.put("packageUserAgent", packageUserAgent);
    constants.put("userAgent", userAgent);
    constants.put("webViewUserAgent", this.getWebViewUserAgent());

    return constants;
  }

  private String getUserAgent() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
      return System.getProperty("http.agent");
    }

    return "";
  }

  private String getWebViewUserAgent() {
    if (Build.VERSION.SDK_INT >= VERSION_CODES.JELLY_BEAN_MR1) {
      return WebSettings.getDefaultUserAgent(this.context);
    }

    WebView webView = new WebView(this.context);
    String userAgentString = webView.getSettings().getUserAgentString();

    this.destroyWebView(webView);

    return userAgentString;
  }

  private void destroyWebView(WebView webView) {
    webView.loadUrl("about:blank");
    webView.stopLoading();

    webView.clearHistory();
    webView.removeAllViews();
    webView.destroyDrawingCache();

    // NOTE: This can occasionally cause a segfault below API 17 (4.2)
    webView.destroy();
  }
}
