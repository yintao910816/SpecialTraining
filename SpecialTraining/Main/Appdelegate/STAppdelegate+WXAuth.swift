//
//  STAppdelegate+WXAuth.swift
//  SpecialTraining
//
//  Created by xujun on 2018/12/18.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation

extension STAppDelegate: WXApiDelegate {
    
    func registerWX() {
        WXApi.registerApp("wxcb1e987d2389e80d")
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        WXApi.handleOpen(url, delegate: self)
        return true
        
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        WXApi.handleOpen(url, delegate: self)
        return true
    }
    
    func onResp(_ resp: BaseResp!) {
        if resp.errCode == 0 {
            let myResp:SendAuthResp = resp as! SendAuthResp
            print(myResp.code)
            ///发送通知
            NotificationCenter.default.post(name: NotificationName.WX.WXAuthLogin, object: nil, userInfo: ["str":myResp.code])
        }
    }
    
}
