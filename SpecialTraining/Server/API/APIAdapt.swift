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
            guard let resultInt = Int(resultString) else {
                return "100"
            }
            return resultInt >= 1000 ? "100" : resultString
        }
    }
    
    /**
     切换用户重新设置请求相关参数
     */
    public func resetParam() {
        //        requestParam = [
        //            "uid":"" ,
        ////            "token":userDefault.token,
        ////            "channel_id":channelId
        //        ]
        
        PrintLog("默认请求参数已改变：\(requestParam)")
    }
}

import Moya

struct APIAssistance {
    
    private static let base     = "http://ai.youpeixunjiaoyu.com/"
    private static let dev_base = "http://alpha.youpeixunjiaoyu.com/"
    
    static public func baseURL(API: API) ->URL{
        //        #if DEBUG
        //        return URL(string: dev_base)!
        //        #else
        return URL(string: dev_base)!
        //        #endif
    }
    
    /**
     请求方式
     */
    static public func mothed(API: API) ->Moya.Method{
        switch API {
        case .register(_, _, _), .login(_, _, _):
            return .post
        default:
            return .get
        }
    }
    
}
