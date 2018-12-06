//
//  MineOrderModel.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/6.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit

class MineOrderModel: HJModel {
    
}

class MineOrderMenuModel: HJModel {
    
    var title: String = ""
    
    var isSelected: Bool = false
    
    class func createModel(title: String, isSelected: Bool = false) -> MineOrderMenuModel {
        let model = MineOrderMenuModel()
        model.title = title
        model.isSelected = isSelected
        
        return model
    }
    
}
