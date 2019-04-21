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
    var shop_id: String = ""
    var shop_name: String = ""
    var order_id: String = ""
    var order_number: String = ""
    var real_amount: String = ""
    var trade_status: String = ""
    var createtime: String = ""
    var pay_type: String = ""
    var orderItem: [OrderItemModel] = []

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
