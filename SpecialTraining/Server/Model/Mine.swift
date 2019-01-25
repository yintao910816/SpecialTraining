//
//  Mine.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/18.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

struct MineModel {
    
    var title: String!
    var image: UIImage?
    
    var isClicked: Bool = true
    
    var segueIdentifier: String?
    
    static func creatModel(title: String, imageString: String = "", segueIdentifier: String? = nil, _ isClicked: Bool = true) ->MineModel {
        var m = MineModel()
        m.title = title
        m.image = UIImage.init(named: imageString)
        m.segueIdentifier = segueIdentifier
        m.isClicked = isClicked
        return m
    }
}

//MARK:
//MARK: 个人中心所有订单
class MemberAllOrderModel: HJModel {
    
}
