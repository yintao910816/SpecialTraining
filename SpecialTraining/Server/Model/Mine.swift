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
    var clickedOrderIdx: Int = 0
    
    var isClicked: Bool = true
    
    var segueIdentifier: String?
    
    static func creatModel(title: String,
                           imageString: String = "",
                           segueIdentifier: String? = nil,
                           clickedOrderIdx: Int = 0,
                           _ isClicked: Bool = true) ->MineModel
    {
        var m = MineModel()
        m.title = title
        m.image = UIImage.init(named: imageString)
        m.segueIdentifier = segueIdentifier
        m.isClicked = isClicked
        m.clickedOrderIdx = clickedOrderIdx
        return m
    }
}
