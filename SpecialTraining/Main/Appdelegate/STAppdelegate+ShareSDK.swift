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
            PrintLog("微信log日资：\(msg)")
        }
        
//        if WXApi.registerApp("wxcb1e987d2389e80d") == true {
//            PrintLog("微信注册成功")
//        }
        
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
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        PrintLog("openURL:\(url.absoluteString)")
        
        
        
        if url.scheme == wxAppid {
            
            return WXApi.handleOpen(url, delegate: self)
            
        }
        

        return true
    }

}

extension STAppDelegate: WXApiDelegate {
 
    public func onResp(_ resp: BaseResp!) {
        
//        if resp.isKindOfClass(BaseResp.classForCoder()) {
        
            //支付返回结果，实际支付结果需要去微信服务器端查询
        
        PrintLog("微信错误提示：\(resp.errStr)")
        
            switch resp.errCode {
                
            case WXSuccess.rawValue:
                
                print("支付成功")
                
                //在这里你是不是可以去干你想干的事了呢
                
                break
                
            default:
                
                //当然了 失败了也是要干事情滴
                
                break
                
            }
            
//        }
        

    }
}
