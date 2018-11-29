//
//  STAppDelegate+EaseMob.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/19.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation

extension STAppDelegate {
    
    func easemobConfig(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
    
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loginStateChage),
                                               name: NotificationName.EaseMob.LoginStateChange,
                                               object: nil)

        let options = EMOptions.init(appkey: easeMobAppKey)
        options?.apnsCertName = ""
        options?.isAutoAcceptGroupInvitation = true
        options?.enableConsoleLog = false
        #if DEBUG
        options?.enableConsoleLog = true
        #endif

        options?.usingHttpsOnly = false
        options?.isAutoTransferMessageAttachments = true
        options?.isAutoDownloadThumbnail = true

        EMClient.shared()?.initializeSDK(with: options!)
    }

    //MARK:
    //MARK: login changed
    @objc func loginStateChage(no: Notification) {
        if let success = no.object as? Bool, success == true {
            PrintLog("环信登录成功")
        }else {
            PrintLog("环信登录失败")
        }
    }
    
}
