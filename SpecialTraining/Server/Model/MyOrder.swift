//
//  MyOrder.swift
//  SpecialTraining
//
//  Created by sw on 21/04/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation

//MARK:
//MARK: 个人中心所有订单
class MemberAllOrderModel: HJModel {
    enum OrderStatu: Int {
        case noPay = 1
        case haspay = 2
        case packBack = 6
    }

    var shop_id: String = ""
    var shop_name: String = ""
    var order_id: String = ""
    var order_number: String = ""
    var real_amount: String = ""
    var trade_status: Int = 1
    var createtime: String = ""
    var pay_type: String = ""
    var orderItem: [OrderItemModel] = []

    public var statue: OrderStatu {
        if let statu = OrderStatu.init(rawValue: trade_status) {
            return statu
        }
        return .noPay
    }
}

class OrderItemModel: HJModel {
    
    var shop_id: String = ""
    var order_number: String = ""
    var course_id: String = ""
    var course_name: String = ""
    var course_pic: String = ""
    var class_id: String = ""
    var class_name: String = ""
    var class_price: String = ""
    var num: String = ""
    var total_fee: String = ""
    var class_category: String = ""
    var createtime: String = ""
}

/// 退款详情
class RefundDetailsModel: HJModel {
    var order_returns_id: String = ""
    var returns_no: String = ""
    var order_number: String = ""
    var shop_id: String = ""
    var consignee_realname: String = ""
    var consignee_telphone: String = ""
    var returns_amount: String = ""
    var return_submit_time: String = ""
    var handling_time: String = ""
    var returns_reason: String = ""
    var returns_status: Int = 0
}
