//
//  STAppdelegate+WXAuth.swift
//  SpecialTraining
//
//  Created by xujun on 2018/12/18.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation

extension STAppDelegate {
    
    func setupShareSDK() {
        if WXApi.registerApp("wxcb1e987d2389e80d") == true {
            PrintLog("微信注册成功")
        }
        
        setup()
    }
    
    private func setup() {
        
        ShareSDK.registerActivePlatforms([SSDKPlatformType.typeWechat.rawValue],
                                         onImport: { platform in
                                            switch platform {
                                            case .typeWechat:
                                                ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                                            default:
                                                break
                                            }
        }) { (platform, appInfo) in
            switch platform {
            case .typeWechat:
                appInfo?.ssdkSetupWeChat(byAppId: "wxcb1e987d2389e80d",
                                         appSecret: "79d8d1710b07f0e96e6f40ee58f5d9fe")
            default:
                break
            }
        }
    }

}
