//
//  MineAccountModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/7.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation

class MineAccountModel: HJModel {
    var total_commission: String = ""
    var can_commission: String = ""
    var item_list: [MineAwardsModel] = []
}

class MineAwardsModel: HJModel {
    var item_id: String = ""
    var order_number: String = ""
    var commission: String = ""
    var status: String = ""
    var level: String = ""
    var member_name: String = ""
    var mob: String = ""
    var createtime: String = ""
}

class MineAwardDetailModel: HJModel {
    var order_number: String = ""
    var commission: String = ""
    var applytime: String = ""
    var paytime: String = ""
    var status: Int = 0
    var nickname: String = ""
    
    var statuText: String {
        switch status {
        case 0:
            return "未知状态"
        default:
            return "可提现"
        }
    }
}
