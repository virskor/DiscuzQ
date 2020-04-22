import Flutter
import UIKit
import SVProgressHUD

public class SwiftFlutterNativeLoadingPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_native_loading", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterNativeLoadingPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let purple = UIColor.black // 1.0 alpha
    let semi = purple.withAlphaComponent(0.5) // 0.5 alpha
    SVProgressHUD.setDefaultStyle(.custom)
    SVProgressHUD.setDefaultMaskType(.custom)
    SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.flat)
    SVProgressHUD.setForegroundColor(UIColor.white)           //Ring Color
    SVProgressHUD.setBackgroundColor(UIColor.clear)        //HUD Color
    SVProgressHUD.setBackgroundLayerColor(semi)
    SVProgressHUD.setRingThickness(5)

    switch call.method {
    case "showLoading":
        SVProgressHUD.show();
    case "hideLoading":
       SVProgressHUD.dismiss()
    default:
       SVProgressHUD.dismiss()
      // result.notImplemented();
    }
  }
}
