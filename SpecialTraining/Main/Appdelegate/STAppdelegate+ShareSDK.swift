//
//  STAppdelegate+WXAuth.swift
//  SpecialTraining
//
//  Created by xujun on 2018/12/18.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
let wxAppid = "wxcb1e987d2389e80d"

extension STAppDelegate {
    
    func setupShareSDK() {
        WXApi.startLog(by: .normal) { msg in
            PrintLog("微信log日志：\(msg ?? "")")
        }
        
        if WXApi.registerApp(wxAppid) == true {
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
                appInfo?.ssdkSetupWeChat(byAppId: wxAppid,
                                         appSecret: "79d8d1710b07f0e96e6f40ee58f5d9fe")
            default:
                break
            }
        }
    }
}

extension STAppDelegate: WXApiDelegate {
 
    public func onResp(_ resp: BaseResp!) {
        
        if resp.isKind(of: BaseResp.classForCoder()) {
            switch resp.errCode {
                
            case WXSuccess.rawValue:
                PrintLog("支付成功")
                NotificationCenter.default.post(name: NotificationName.WX.WXPay, object: (true, ""))
            default:
                NotificationCenter.default.post(name: NotificationName.WX.WXPay, object: (false, resp.errStr ?? ""))
            }
            
        }
    }
}
