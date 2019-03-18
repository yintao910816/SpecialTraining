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
    case login(mobile: String, code: String)
    /// 微信登录
    case wxLogin(code: String)
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
    
    // 开设课程 http://api.youpeixunjiaoyu.com/v1/agency/agnCourse?agn_id=1
    case agnCourse(agn_id: String)
    // 推荐活动 http://api.youpeixunjiaoyu.com/v1/agency/agnActivity?agn_id=1
    case agnActivity(agn_id: String)
    // 老师风采 http://api.youpeixunjiaoyu.com/v1/agency/agnTeachers?agn_id=1
    case agnTeachers(agn_id: String)
    
    // 店铺 - 开设课程
    case shopCourse(shop_id: String)
    // 店铺 - 推荐活动
    case shopActivity(shop_id: String)
    // 店铺 - 老师风采
    case shopTeachers(shop_id: String)
    
    
    // 机构详情
    case agencyDetail(id: String)
    /// 师资
    case agnTeachers(agnId: String)
    
    /// 机构店铺
    case agnShop(id: String)
    //MARK:
    //MARK: 购物车

    /// 课程详情
    /// 相关校区
    case relateShop(course_id: String)
    /// 上课时间
    case classTime(course_id: String)
    /// 精彩内容/上课音频 --- type: A:上课音频 V:精彩内容
    case courseVideoOrAudio(course_id: String, type: String)
    /// 详情顶部内容
    case course(id: String)
    /// 获取班级
    case selectClass(course_id: String)
    /// 提交订单
    case submitOrder(params: [String: Any])
    /// 微信支付统一下单 api.youpeixunjiaoyu.com/v1/pay/wxPay?order_number=DL2437140294456282&real_amount=3560
    case wxPay(order_number: String, real_amount: String)
    /// 获取支付宝支付订单字符串
    case alipay(order_number: String)
    
    //MARK:
    //MARK: 个人中心
    /// 所有订单 api.youpeixunjiaoyu.com/v1/order/getMemberAllOrder?member_id=1
    case getMemberAllOrder(member_id: String)
}

//MARK:
//MARK: TargetType 协议
extension API: TargetType{
    
    var path: String{
        switch self {
        case .register(_, _, _):
            return "member/registerImUser"
        case .login(_, _):
            // http://api.youpeixunjiaoyu.com/v1/login/mobLogin?appid=ypxcb1e987d2389e80d&mobile=18627844751&code=9067
            return "v1/login/mobLogin"
        case .wxLogin(_):
            return "v1/login/wxLogin"
        case .getUserInfo(_):
            return "member/read"
        case .setPassword(_, _, _):
            return "server/auth/set_pswd.php"
        case .sendCode(_):
            return "server/sms/send_sms.php"
        case .refreshToken(_):
            return "server/auth/reflesh_auth.php"
        case .thirdPartyLogin(_):
            return "server/third_party_login/wx.php"
        case .bindWX(_, _):
            return "server/third_party_login/bind_wx.php"
        case .bindPhone(_, _, _):
            return "server/third_party_login/bind_mobile.php"
        case .nearCourse(_, _, _):
            return "v1/index/nearCourse"
        case .activityCourse(_):
            return "v1/index/activityCourse"
        case .agency(_, _, _):
            return "v1/agency/index"
        case .agnShop(_):
            return "v1/agency/read"
            
        case .agnCourse(_):
            return "v1/agency/agnCourse"
        case .agnActivity(_):
            return "v1/agency/agnActivity"
        case .agnTeachers(_):
            return "v1/agency/agnTeachers"
        
        case .agencyDetail(_):
            return "v1/agency/read"
            
        case .shopCourse(_):
            return "v1/shop/shopCourse"
        case .shopActivity(_):
            return "v1/shop/shopActivity"
        case .shopTeachers(_):
            return "v1/agency/agnTeachers"
            
        case .relateShop(_):
            return "v1/course/relateShop"
        case .classTime(_):
            return "v1/course/classTime"
        case .courseVideoOrAudio(_, _):
            return "v1/course/courseVideoOrAudio"
        case .course(_):
            return "v1/course/read"
        case .selectClass(_):
            return "v1/course/selectClass"
        
        case .submitOrder(_):
            return "v1/order/submitOrder"
        case .wxPay(_, _):
            return "v1/pay/wxPay"
        case .alipay(_):
            return "v1/pay/aliPay"
            
        case .getMemberAllOrder(_):
            return "v1/order/getMemberAllOrder"
        }
    }
    
    var baseURL: URL{ return APIAssistance.baseURL(API: self) }
    
    var task: Task {
        switch self {
        case .submitOrder(let params):
            let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
            PrintLog("提交订单参数：\(try! JSONSerialization.jsonObject(with: jsonData!, options: []))")
            return .requestData(jsonData ?? Data())
        default:
            if let _parameters = parameters {
                return .requestParameters(parameters: _parameters, encoding: URLEncoding.default)
            }
            return .requestPlain
        }
    }
    
    var method: Moya.Method { return APIAssistance.mothed(API: self) }
    
    var sampleData: Data{ return stubbedResponse("ttt") }
    
    var validate: Bool { return false }
    
    var headers: [String : String]? {
        return ["authentication": userDefault.token]
    }
    
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
        case .login(let mobile, let code):
            params["mobile"] = mobile
            params["code"] = code
            params["appid"] = "ypxcb1e987d2389e80d"
        case .wxLogin(let code):
            params["code"] = code
            params["appid"] = "ypxcb1e987d2389e80d"
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
            params["lat"] = userDefault.lat
            params["lng"] = userDefault.lng
            params["offset"] = offset
        case .activityCourse(let offset):
            params["offset"] = offset
        case .agency(let lat, let lng, let offset):
            params["lat"] = userDefault.lat
            params["lng"] = userDefault.lng
            params["offset"] = offset
            
        case .agnCourse(let agn_id):
            params["agn_id"] = agn_id
        case .agnActivity(let agn_id):
            params["agn_id"] = agn_id
        case .agnTeachers(let agn_id):
            params["agn_id"] = agn_id
        case .agnShop(let id):
            params["id"] = id
            params["lat"] = userDefault.lat
            params["lng"] = userDefault.lng

        case .agencyDetail(let id):
            params["id"] = id
        case .shopCourse(let shop_id):
            params["shop_id"] = shop_id
        case .shopActivity(let shop_id):
            params["shop_id"] = shop_id
        case .shopTeachers(let shop_id):
            params["agn_id"] = shop_id
            
        case .relateShop(let course_id):
            params["course_id"] = course_id
            params["lat"] = userDefault.lat
            params["lng"] = userDefault.lng
        case .classTime(let course_id):
            params["course_id"] = course_id
        case .courseVideoOrAudio(let course_id, let type):
            params["course_id"] = course_id
            params["type"] = type
        case .course(let id):
            params["id"] = id
        case .selectClass(let course_id):
            params["course_id"] = course_id
            
        case .wxPay(let order_number, let real_amount):
            params["order_number"] = order_number
//            params["real_amount"]  = real_amount
        case .alipay(let order_number):
            params["order_number"] = order_number
            
        case .getMemberAllOrder(let member_id):
            params["member_id"] = member_id
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
