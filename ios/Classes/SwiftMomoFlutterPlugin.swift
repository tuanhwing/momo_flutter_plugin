import Flutter
import UIKit

public class SwiftMomoFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: MomoFlutterPluginChannels.methodChannel, binaryMessenger: registrar.messenger())
    let instance = SwiftMomoFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    ///Register applicaion deligate
    registrar.addApplicationDelegate(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    switch call.method {
        case MomoFlutterPluginMethods.initialize:
            MomoPaymentManager.shared.initlize(develop: call.arguments as? Bool)
            break
        case MomoFlutterPluginMethods.makePayment:
            Logger.d("makePayment called")
            guard let options = call.arguments as? NSMutableDictionary else {
                Logger.e("payment info invalid!")
                result([
                   "status" : MoMoPaymentStatuses.somethingWentWrong,
                   "message" : "payment isn't NSMutableDictionary type!"
                ])
                return
            }
            MomoPaymentManager.shared.makePaymentRequest(info: options, result: result)
            break
        default:
            Logger.e("function not found!")
    }
  }
    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String, annotation: Any) -> Bool {
        Logger.d("openURL:sourceApplication:")
        MoMoPayment.handleOpenUrl(url: url, sourceApp: sourceApplication)
        return true
    }

    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        Logger.d("openURL:options:")
        MoMoPayment.handleOpenUrl(url: url, sourceApp: "")
        return true
    }
}
