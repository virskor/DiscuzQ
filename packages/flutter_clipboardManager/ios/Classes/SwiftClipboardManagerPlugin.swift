import Flutter
import UIKit

public class SwiftClipboardManagerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "clipboard_manager", binaryMessenger: registrar.messenger())
    let instance = SwiftClipboardManagerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments! as! [String:Any]
    UIPasteboard.general.string = args["text"] as? String
    result(true)
  }
}
