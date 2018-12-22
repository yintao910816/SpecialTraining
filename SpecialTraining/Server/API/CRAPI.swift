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
    case login(mobile: String, code: String, pswd: String)
    // 获取用户信息
    case getUserInfo(uid: String)
    //设置/修改密码
    case setPassword(mobile: String, code: String, pswd: String)
    //发送短信验证码
    case sendCode(mobile: String)
    //刷新token
    case refreshToken(token: String)
    //微信登陆
    case thirdPartyLogin(code: String)
    //绑定微信
    case bindWX(token: String, code: String)
    //绑定手机号
    case bindPhone(mobile: String, code: String, op_openid: String)
    
    // 附近课程
    case nearCourse(lat: CLLocationDegrees, lng: CLLocationDegrees, offset: Int)
    // 体验专区
    case activityCourse(offset: Int)
    // 附近机构
    case agency(lat: CLLocationDegrees, lng: CLLocationDegrees, offset: Int)
}

//MARK:
//MARK: TargetType 协议
extension API: TargetType{
    
    var path: String{
        switch self {
        case .register(_, _, _):
            return "member/registerImUser"
        case .login(_, _, _):
            return "/server/auth/login.php"
        case .getUserInfo(_):
            return "member/read"
        case .setPassword(_, _, _):
            return "/server/auth/set_pswd.php"
        case .sendCode(_):
            return "/server/sms/send_sms.php"
        case .refreshToken(_):
            return "/server/auth/reflesh_auth.php"
        case .thirdPartyLogin(_):
            return "/server/third_party_login/wx.php"
        case .bindWX(_, _):
            return "/server/third_party_login/bind_wx.php"
        case .bindPhone(_, _, _):
            return "/server/third_party_login/bind_mobile.php"
        case .nearCourse(_, _, _):
            return "v1/index/nearCourse"
        case .activityCourse(_):
            return "v1/index/activityCourse"
        case .agency(_, _, _):
            return "v1/agency"
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
        case .login(let mobile, let code, let pswd):
            params["mobile"] = mobile
            params["code"] = code
            params["pswd"] = pswd
        case .getUserInfo(let uid):
            params["id"] = uid
        case .setPassword(let mobile, let code, let pswd):
            params["mobile"] = mobile
            params["code"] = code
            params["pswd"] = pswd
        case .sendCode(let mobile):
            params["mobile"] = mobile
        case .refreshToken(let token):
            params["token"] = token
        case .thirdPartyLogin(let code):
            params["code"] = code
        case .bindWX(let token, let code):
            params["token"] = token
            params["code"] = code
        case .bindPhone(let mobile, let code, let op_openid):
            params["mobile"] = mobile
            params["code"] = code
            params["op_openid"] = op_openid
        case .nearCourse(let lat, let lng, let offset):
//            params["lat"] = lat
//            params["lng"] = lng
            params["lat"] = 112.21791
            params["lng"] = 30.356023
            params["offset"] = offset
        case .activityCourse(let offset):
            params["offset"] = offset
        case .agency(let lat, let lng, let offset):
            params["lat"] = 112.21791
            params["lng"] = 30.356023
            params["offset"] = offset
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
