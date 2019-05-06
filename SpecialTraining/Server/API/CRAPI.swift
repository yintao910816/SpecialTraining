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
    case bindPhone(mob: String, code: String, nickname: String, sex: String, headimgurl: String, openid: String)
    
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
    /// 店铺二级界面
    case shopRead(shopId: String)
    //MARK:
    //MARK: 购物车

    /// 课程详情
    case courseDetail(id: String)
    /// 获取班级
    case selectClass(course_id: String)
    /// 班级详情
    case courseClassInfo(classId: String, shop_id: String)
    /// 提交订单
    case submitOrder(params: [String: Any])
    /// 微信支付统一下单 api.youpeixunjiaoyu.com/v1/pay/wxPay?order_number=DL2437140294456282&real_amount=3560
    case wxPay(order_number: String, real_amount: String)
    /// 获取支付宝支付订单字符串
    case alipay(order_number: String)
    
    //MARK:
    //MARK: 个人中心
    /// 所有订单
    case getMemberAllOrder(member_id: String)
    /// 取消订单
    case cancleOrder(order_no: String)
    /// 退款
    case refundOrder(order_no: String)
    /// 取消退款
    case canclePayBack(order_no: String)
    /// 获取退款信息
    case refundDetails(order_no: String)
    
    /// 意见反馈
    case feedback(category_id: String, content: String, contact: String, member_id: String)
    
    //MARK:
    //MARK: 文件上传
    case aliyunUpLoadAuth(title: String, filename: String, cate_id: String, member_id: String)
    case sts()
    // 视屏上传阿里云成功后上传app服务器
    case insert_video_info(vodSVideoModel: VodSVideoUploadResult, cateID: String, title: String)
    // 完的乐秀视频
    case myVideo()
    
    // 乐秀视屏列表
    case videoList(cate_id: String)
    
    // 文件下载
    case downLoad(url: String, mediaType: FileCacheType)
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
            return "v1/login/sendSms"
        case .refreshToken(_):
            return "server/auth/reflesh_auth.php"
        case .thirdPartyLogin(_):
            return "server/third_party_login/wx.php"
        case .bindWX(_, _):
            return "server/third_party_login/bind_wx.php"
        case .bindPhone(_):
            return "v1/login/bindMob"
        case .nearCourse(_, _, _):
            return "v1/index/nearCourse"
        case .activityCourse(_):
            return "v1/index/activityCourse"
        case .agency(_, _, _):
            return "v1/agency/index"
        case .agnShop(_):
            return "v1/agency/read"
        case .shopRead(_):
            return "v1/shop/read"
            
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
        case .courseDetail(_):
            return "v1/course/read"
        case .selectClass(_):
            return "v1/course/selectClass"
        case .courseClassInfo(_):
            return "v1/courseClass/read"
            
        case .submitOrder(_):
            return "v1/order/submitOrder"
        case .wxPay(_, _):
            return "v1/pay/wxPay"
        case .alipay(_):
            return "v1/pay/aliPay"
            
        case .getMemberAllOrder(_):
            return "v1/order/getMemberAllOrder"
        case .cancleOrder(_):
            return "v1/order/orderCancel"
        case .refundOrder(_):
            return "v1/order/refund_order"
        case .canclePayBack(_):
            return "v1/order/canncel_refund"
        case .refundDetails(_):
            return "v1/order/refund_details"
            
        case .feedback(_):
            return "v1/member/feedback"
            
        case .sts():
            return "v1/video/get_video_sts"
        case .aliyunUpLoadAuth(_):
            return "v1/video/upload_video"
        case .insert_video_info(_):
            return "v1/video/insert_video_info"
            
        case .videoList(_):
            return "v1/video/video_list"
            
        case .myVideo():
            return "v1/video/my_video"
        
        case .downLoad(_, _):
            return ""
        }
    }
    
    var baseURL: URL{
        switch self {
        case .downLoad(let url, _):
            return URL.init(string: url)!
        default:
            return APIAssistance.baseURL(API: self)
        }
    }
    
    var task: Task {
        switch self {
        case .submitOrder(let params):
            let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
            PrintLog("提交订单参数：\(try! JSONSerialization.jsonObject(with: jsonData!, options: []))")
            return .requestData(jsonData ?? Data())
        case .downLoad(_):
            if let destination = downloadVideoDestination {
                return .downloadDestination(destination)
            }
            return .requestPlain
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
            params["mob"] = mobile
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
        case .bindPhone(let mob, let code, let nickname, let sex, let headimgurl, let openid):
            params["mob"] = mob
            params["code"] = code
            params["nickname"] = nickname
            params["sex"] = sex
            params["headimgurl"] = headimgurl
            params["openid"] = openid
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
        case .getMemberAllOrder(let member_id):
            params["member_id"] = member_id
        case .cancleOrder(let order_no):
            params["order_no"] = order_no
        case .refundOrder(let order_no):
            params["order_no"] = order_no
        case .canclePayBack(let order_no):
            params["order_no"] = order_no
        case .refundDetails(let order_no):
            params["order_no"] = order_no
            
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
        case .shopRead(let shopId):
            params["id"] = shopId

        case .courseDetail(let id):
            params["id"] = id

        case .agencyDetail(let id):
            params["id"] = id
        case .shopCourse(let shop_id):
            params["shop_id"] = shop_id
        case .shopActivity(let shop_id):
            params["shop_id"] = shop_id
        case .shopTeachers(let shop_id):
            params["agn_id"] = shop_id
            
        case .selectClass(let course_id):
            params["course_id"] = course_id
        case .courseClassInfo(let classId, let shop_id):
            params["id"] = classId
            params["shop_id"] = shop_id

        case .wxPay(let order_number, let real_amount):
            params["order_number"] = order_number
//            params["real_amount"]  = real_amount
        case .alipay(let order_number):
            params["order_number"] = order_number
            
        case .feedback(let category_id, let content, let contact, let member_id):
            params["category_id"] = category_id
            params["content"] = content
            params["contact"] = contact
            params["member_id"] = member_id

        case .aliyunUpLoadAuth(let title, let filename, let cate_id, let member_id):
            params["title"] = title
            params["filename"] = filename
            params["cate_id"] = cate_id
            params["member_id"] = member_id
            
        case .insert_video_info(let vodSVideoModel, let cate_id, let title):
            params["member_id"] = userDefault.uid
            params["cate_id"]   = cate_id
            params["cover_url"] = vodSVideoModel.imageUrl
            params["title"]     = title
            params["video_id"]  = vodSVideoModel.videoId
            
        case .myVideo():
            params["member_id"] = userDefault.uid

        case .videoList(let cate_id):
            params["cate_id"] = cate_id
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

extension API {
    
    private var downloadVideoDestination: DownloadDestination? {
        switch self {
        case .downLoad(let url, let type):
            let filePath = FileHelper.share.getCachePath(type: type) + url.md5
            let url = URL.init(fileURLWithPath: filePath)
            return { _, _ in return (url, [.removePreviousFile, .createIntermediateDirectories]) }
        default:
            return nil
        }
    }
}

//MARK:
//MARK: API server

import Alamofire

let STProvider = MoyaProvider<API>(plugins: [MoyaPlugins.MyNetworkActivityPlugin,
                                             RequestLoadingPlugin()]).rx

//let STHttpsProvider = MoyaProvider<API>.init(manager: defaultAlamofireManager(),
//                                             plugins: [MoyaPlugins.MyNetworkActivityPlugin, RequestLoadingPlugin()],
//                                             trackInflights: false).rx
//
//private func defaultAlamofireManager() -> Manager {
//    let configuration = URLSessionConfiguration.default
//    configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
//    //获取本地证书
//    let path: String = Bundle.main.path(forResource: "youpeixunjiaoyu", ofType: "cer")!
//    let certificateData = try? Data(contentsOf: URL(fileURLWithPath: path))
//    print(certificateData?.count)
//    let certificateCFData = (certificateData as! CFData)
//    print(certificateCFData)
//    let certificate = SecCertificateCreateWithData(nil, certificateCFData)
//    let certificates :[SecCertificate] = [certificate!]
//
//    let policies: [String: ServerTrustPolicy] = [
//        "youpeixunjiaoyu" : .pinCertificates(certificates: certificates, validateCertificateChain: true, validateHost: true)
//    ]
//    let manager = Alamofire.SessionManager(configuration: configuration,serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
//    return manager
//}
