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
    
    private static let base = "http://api.youpeixunjiaoyu.com/"

    static public func baseURL(API: API) ->URL{
        switch API {
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
             .submitOrder(_),
             .wxPay(_, _),
             .alipay(_):
            return .post
        default:
            return .get
        }
    }
    
    /// 拼接h5链接
    static func courseDetailH5URL(courseId: String) ->URL? {
        let urlStr = base + "v1/course/course_content?id=\(courseId)"
        return URL.init(string: urlStr)
    }
    
    static func classDetailH5URL(classId: String) ->URL? {
        let urlStr = base + "v1/courseClass/class_content?id=\(classId)"
        return URL.init(string: urlStr)
    }
}
