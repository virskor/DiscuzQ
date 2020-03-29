import Flutter
import UIKit

public class SwiftFlutterNativeDialogPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        // Need to make registrar an optional to supress Swift compiler warning
        let pluginRegistrar: FlutterPluginRegistrar? = registrar
        if (pluginRegistrar != nil) {
            let channel = FlutterMethodChannel(name: "flutter_native_dialog", binaryMessenger: registrar.messenger())
            let instance = SwiftFlutterNativeDialogPlugin()
            registrar.addMethodCallDelegate(instance, channel: channel)
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (!call.method.starts(with: "dialog.")) {
            result(FlutterMethodNotImplemented)
            return
        }
        
        let alertData = AlertData(withDictionary: call.arguments as! Dictionary<String, Any>)
        let alertController = buildAlert(method: call.method, alertData: alertData, result: result)
        
        if let topController = getTopViewController() {
            topController.present(alertController, animated: true)
        } else {
            result(FlutterError(code: "no_view_controller", message: "No ViewController available to present a dialog", details: nil))
        }
    }
    
    private func buildAlert(method: String, alertData: AlertData, result: @escaping FlutterResult) -> UIAlertController {
        switch method {
        case "dialog.confirm":
            return buildConfirmDialog(alertData: alertData, result: result)
        default:
            return buildAlertDialog(alertData: alertData, result: result)
        }
    }
    
    private func buildAlertDialog(alertData: AlertData, result: @escaping FlutterResult) -> UIAlertController {
        let alertController = buildAlertController(title: alertData.title, message: alertData.message)
        alertController.addAction(UIAlertAction(title: alertData.positiveButtonText, style: .default, handler: { _ in
            result(true)
        }))
        return alertController
    }
    
    private func buildConfirmDialog(alertData: AlertData, result: @escaping FlutterResult) -> UIAlertController {
        let alertController = buildAlertController(title: alertData.title, message: alertData.message)
        alertController.addAction(UIAlertAction(title: alertData.positiveButtonText, style: alertData.destructive ? .destructive : .default, handler: { _ in
            result(true)
        }))
        alertController.addAction(UIAlertAction(title: alertData.negativeButtonText, style: .cancel, handler: { _ in
            result(false)
        }))
        return alertController
    }
    
    private func buildAlertController(title: String?, message: String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    }
    
    private func getTopViewController() -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        
        return nil
    }
}
