//
//  Order.swift
//  SpecialTraining
//
//  Created by yintao on 2019/1/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation

class OrderModel: HJModel {

    var order_id: String = ""
    var order_number: String = ""
    var real_amount: String = ""
    var pay_time: String = ""
    var pay_type: String = ""
    var createtime: String = ""
    var trade_status: String = ""
    var parent_id: String = ""
    var is_split: String = ""

}

import HandyJSON
class WchatPayModel: HJModel {
    var appid: String = ""
    /** 商家向财付通申请的商家id */
    var partnerId: String = ""
    /** 预支付订单 */
    var prepayId: String = ""
    /** 随机串，防重发 */
    var nonceStr: String = ""
    /** 时间戳，防重发 */
    var timeStamp: String = ""
    /** 商家根据财付通文档填写的数据和签名 */
    var package: String = "Sign=WXPay"
    /** 商家根据微信开放平台文档对数据做的签名 */
    var sign: String = ""

    override func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &nonceStr, name: "noncestr")
        mapper.specify(property: &partnerId, name: "partnerid")
        mapper.specify(property: &prepayId, name: "prepayid")
        mapper.specify(property: &timeStamp, name: "timestamp")
    }
}
