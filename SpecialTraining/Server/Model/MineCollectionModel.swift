//
//  MineCollectionModel.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/7.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit

class MineCollectionModel: HJModel {
    var image: String = ""
    var title: String = ""
    var tag: String = ""
    var time: String = ""
}

class MineCollectionHeaderModel: HJModel {
    
    var title: String = ""
    var isSelected: Bool = false
    
    class func createModel(title:String, isSelected: Bool = false) -> MineCollectionHeaderModel {
        let model = MineCollectionHeaderModel()
        model.title = title
        model.isSelected = isSelected
        return model
    }
    
}
