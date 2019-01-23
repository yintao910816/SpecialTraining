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

        DbManager.dbSetup()
        // 环信
        easemobConfig(application: application, launchOptions: launchOptions)
        // 百度
        baiduMapConfig(application: application, launchOptions: launchOptions)
        //shareSDK
        setupShareSDK()
        
//        #if DEBUG
//        STHelper.login(account: "666666", password: "111111")
//        #endif
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        EMClient.shared()?.applicationDidEnterBackground(application)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        EMClient.shared()?.applicationWillEnterForeground(application)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        PrintLog("openURL:\(url.absoluteString)")
        if url.scheme == wxAppid {
            return WXApi.handleOpen(url, delegate: self)
        }
        return true
    }
    
}

