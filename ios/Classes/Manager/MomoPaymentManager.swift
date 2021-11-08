//
//  MomoPaymentManager.swift
//  momo_flutter_plugin
//
//  Created by Tuấn Hwing on 11/6/21.
//

import Foundation

class MomoPaymentManager {
    static let shared = MomoPaymentManager()
        
    init(){}
    
    private var momoFlutterResult:FlutterResult? = nil
    private var isDevelopment:Bool = true
        
    /**
     * Add observer of NotificationCenter
     */
    func initlize(develop:Bool?) {
        Logger.d("start")
        isDevelopment = develop ?? true
        NotificationCenter.default.addObserver(self, selector: #selector(self.NoficationCenterTokenStartRequest), name:NSNotification.Name(rawValue: "NoficationCenterTokenStartRequest"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.NoficationCenterTokenReceived), name:NSNotification.Name(rawValue: "NoficationCenterTokenReceived"), object: nil)
        
        Logger.d("end")
    }
    
    /**
     * Make payment request with information
     */
    func makePaymentRequest(info:NSMutableDictionary, result:@escaping FlutterResult) {
        Logger.d(info)
        
        //Result callback that used when receive notification from momo sdk
        momoFlutterResult = result
        let appScheme = "\(MOMO_APP_BUNDLE_ID)://app"
        
        if UIApplication.shared.canOpenURL(URL(string: appScheme)!) {
            MoMoPayment.createPaymentInformation(info: info)
            MoMoPayment.requestToken()
        }
        else {
            let message = "MoMo application isn't installed!"
            Logger.e(message)
            self.momoFlutterResult?([
                "status" : MoMoPaymentStatuses.appNotInstalled,
                "message" : message
            ])
        }
    }
    
    // MARK: NOTIFICATION HANDLER
    @objc func NoficationCenterTokenStartRequest(notification: NSNotification) {
        Logger.d("::MoMoPay NoficationCenterTokenStartRequest::\(notification.object!)")
    }
    
    @objc func NoficationCenterTokenReceived(notification: NSNotification) {
        
        Logger.d("::MoMoPay NoficationCenterTokenReceived:\(notification.object!)")
        guard let response:NSMutableDictionary = notification.object as? NSMutableDictionary else {
            self.momoFlutterResult?([
                "status" : MoMoPaymentStatuses.somethingWentWrong,
                "message" : "Something went wrong!"
            ])
            return
        }
        
        self.momoFlutterResult?([
            "status" : response["status"],
            "token" : response["data"],
            "phoneNumber" : response["phonenumber"],
            "extra" : response["extra"]
        ])
        
    }
}
