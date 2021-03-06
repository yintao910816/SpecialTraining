//
//  STAppdelegate+WXAuth.swift
//  SpecialTraining
//
//  Created by xujun on 2018/12/18.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation

extension STAppDelegate {

    struct Account {
        static let wxAppid = "wxcb1e987d2389e80d"
        static let wx_appSecret = "79d8d1710b07f0e96e6f40ee58f5d9fe"

        static let share_AppKey = "296a8c21b4cfe"
        static let share_AppSecret = "cb96ac9fc87e03e1e47145261b98fc67"
    }
    
    func setupShareSDK() {
        WXApi.startLog(by: .normal) { msg in
            PrintLog("微信log日志：\(msg ?? "")")
        }
        
        if WXApi.registerApp(Account.wxAppid) == true {
            PrintLog("微信注册成功")
        }
        
        setup()
    }
    
    private func setup() {
        ShareSDK.registPlatforms { platformRegister in
            platformRegister?.setupWeChat(withAppId: Account.wxAppid, appSecret: Account.wx_appSecret)
        }
    }
}

extension STAppDelegate: WXApiDelegate {
 
    public func onResp(_ resp: BaseResp!) {
        
        if resp.isKind(of: PayResp.classForCoder()) {
            switch resp.errCode {
            case WXSuccess.rawValue:
                PrintLog("支付成功")
                NotificationCenter.default.post(name: NotificationName.WX.WXPay, object: (true, ""))
            default:
                NotificationCenter.default.post(name: NotificationName.WX.WXPay, object: (false, resp.errStr ?? ""))
            }
        }
       
        if let authResp = resp as? SendAuthResp {
            NotificationCenter.default.post(name: NotificationName.WX.WXAuthLogin, object: authResp.code)
        }
        
    }
}
