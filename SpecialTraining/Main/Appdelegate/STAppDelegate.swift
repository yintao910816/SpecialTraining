//
//  AppDelegate.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class STAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let chatRoomManager = EaseMobMessageManager()
    
    class var appDelegate: STAppDelegate {
        get {
            return UIApplication.shared.delegate as! STAppDelegate
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = STMainTabBarController()
        
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white

        configAppData()
        // 环信
        easemobConfig(application: application, launchOptions: launchOptions)
        // 百度
        baiduMapConfig(application: application, launchOptions: launchOptions)
        //shareSDK
        setupShareSDK()
                
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        EMClient.shared()?.applicationDidEnterBackground(application)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        EMClient.shared()?.applicationWillEnterForeground(application)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        if (url.host ?? "" ) == "safepay" {
            //跳转支付宝钱包进行支付，处理支付结果
            AlipaySDK.defaultService()?.processOrder(withPaymentResult: url) { [unowned self] resultDic in
                self.dealAlipay(resultDic: resultDic)
            }
            
//            AlipaySDK.defaultService()?.processAuthResult(url, standbyCallback: { resultDic in
//                PrintLog("222222222222 -- \(resultDic)")
//            })
        }

        if url.scheme == Account.wxAppid {
            return WXApi.handleOpen(url, delegate: self)
        }
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if (url.host ?? "" ) == "safepay" {
            //跳转支付宝钱包进行支付，处理支付结果
            AlipaySDK.defaultService()?.processOrder(withPaymentResult: url) { [unowned self] resultDic in
                self.dealAlipay(resultDic: resultDic)
            }
            
//            AlipaySDK.defaultService()?.processAuthResult(url, standbyCallback: { resultDic in
//                PrintLog("444444444444 -- \(resultDic)")
//            })
        }
        
        if url.scheme == Account.wxAppid {
            return WXApi.handleOpen(url, delegate: self)
        }

        return true
    }
}

extension STAppDelegate {
    
    // 处理支付宝支付结果
    private func dealAlipay(resultDic: [AnyHashable: Any]?) {
        PrintLog("支付宝支付结果 -- \(resultDic)")
        guard let jsonDic = resultDic as? [String: Any] else {
            NotificationCenter.default.post(name: NotificationName.AliPay.aliPayBack, object: (false, "未知结果"))
            return
        }
        
        if let code = jsonDic["resultStatus"] as? String, code == "9000" {
            NotificationCenter.default.post(name: NotificationName.AliPay.aliPayBack, object: (true, "支付成功"))
        }else {
            NotificationCenter.default.post(name: NotificationName.AliPay.aliPayBack, object: (false, "未知结果"))
        }
    }
}

