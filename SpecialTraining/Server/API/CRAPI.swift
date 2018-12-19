//
//  SRUserAPI.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/11/25.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation
import Moya

//MARK:
//MARK: 接口定义
enum API{
    // 用户注册
    case register(username: String, password: String, nickname: String)
    // 登录
    case login(username: String, password: String)
    // 获取用户信息
    case getUserInfo(uid: String)

    // 附近课程
    case nearCourse(lat: CLLocationDegrees, lng: CLLocationDegrees)
    // 体验专区
    case activityCourse()
}

//MARK:
//MARK: TargetType 协议
extension API: TargetType{
    
    var path: String{
        switch self {
        case .register(_, _, _):
            return "member/registerImUser"
        case .login(_, _):
            return "member/loginMember"
        case .getUserInfo(_):
            return "member/read"
        case .nearCourse(_, _):
            return "index/nearCourse"
        case .activityCourse():
            return "index/activityCourse"
        }
    }
    
    var baseURL: URL{ return APIAssistance.baseURL(API: self) }
   
    var task: Task {
        if let _parameters = parameters {
            return .requestParameters(parameters: _parameters, encoding: URLEncoding.default)
        }
        return .requestPlain
    }
    
    var method: Moya.Method { return APIAssistance.mothed(API: self) }
    
    var sampleData: Data{ return stubbedResponse("ttt") }

    var validate: Bool { return false }
    
    var headers: [String : String]? { return nil }
    
}

//MARK:
//MARK: 请求参数配置
extension API {
    
    private var parameters: [String: Any]? {
        var params = AppSetup.instance.requestParam
        switch self {
        case .register(let username, let password, let nickname):
            params["username"] = username
            params["password"] = password
            params["nickname"] = nickname
        case .login(let username, let password):
            params["username"] = username
            params["password"] = password
        case .getUserInfo(let uid):
            params["id"] = uid
        case .nearCourse(let lat, let lng):
            params["lat"] = lat
            params["lng"] = lng
        default:
            break
        }
        return params
    }
}


func stubbedResponse(_ filename: String) -> Data! {
    @objc class TestClass: NSObject { }
    
    let bundle = Bundle(for: TestClass.self)
    let path = bundle.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}

//MARK:
//MARK: API server
let STProvider = MoyaProvider<API>(plugins: [MoyaPlugins.MyNetworkActivityPlugin,
                                               RequestLoadingPlugin()]).rx
