//
//  AppSetup.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/11/25.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation

class AppSetup {
    
    static let instance = AppSetup()
    
    var requestParam: [String : Any] = [:]
    
    /**
     版本号拼接到所有请求url
     不能超过1000
     */
    var urlVision: String{
        get{
            // 获取版本号
            let versionInfo = Bundle.main.infoDictionary
            let appVersion = versionInfo?["CFBundleShortVersionString"] as! String
            let resultString = appVersion.replacingOccurrences(of: ".", with: "")
            return resultString
        }
    }
    
    /**
     切换用户重新设置请求相关参数
     */
    public func resetParam() {
//                requestParam = [
//                    "uid": userDefault.uid,
//                    "token": userDefault.token
//        ]
        
        PrintLog("默认请求参数已改变：\(requestParam)")
    }
}

import Moya

struct APIAssistance {
    
    private static let userBase = "http://alpha.youpeixunjiaoyu.com/"
    private static let base   = "http://api.youpeixunjiaoyu.com/"

    static public func baseURL(API: API) ->URL{
        switch API {
        case .bindPhone(_, _, _),
             .sendCode(_),
             .setPassword(_,  _, _),
             .register(_, _, _),
             .getUserInfo(_),
             .refreshToken( _),
             .thirdPartyLogin(_),
             .bindWX(token: _, _):
            return URL(string: userBase)!
        default:
            return URL(string: base)!
        }
    }
    
    /**
     请求方式
     */
    static public func mothed(API: API) ->Moya.Method{
        switch API {
        case .register(_, _, _),
//             .login(_, _),
             .submitOrder(_),
             .wxPay(_, _),
             .alipay(_):
            return .post
        default:
            return .get
        }
    }
    
}
