import Flutter
import UIKit

public class SwiftMomoFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: MomoFlutterPluginChannels.methodChannel, binaryMessenger: registrar.messenger())
    let instance = SwiftMomoFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
   
    MomoPaymentManager.shared.initlize()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    switch call.method {
        case MomoFlutterPluginMethods.makePayment:
            Logger.d("makePayment called")
            guard let options = call.arguments as? NSMutableDictionary else {
                Logger.e("payment info invalid!")
                return
            }
            MomoPaymentManager.shared.makePaymentRequest(info: options, result: result)
            break
        default:
            Logger.e("function not found!")
    }
  }
}
