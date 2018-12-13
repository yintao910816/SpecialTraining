//
//  MineInfo.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/19.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class MineInfoModel: MineInfoModelAdapt {
    
    var title: String!
    var detailTitle: String?
    var detailImage: UIImage?
    
    class func creatModel(title: String, detailTitle: String? = nil, detailImageStr: String = "") ->MineInfoModel {
        let m = MineInfoModel()
        m.title = title
        m.detailTitle = detailTitle
        m.detailImage = detailImageStr.count > 0 ? UIImage.init(named: detailImageStr) : nil
        return m
    }
    
    var height: CGFloat {
        return title == "头像" ? 80 : 45
    }
}

class StudentInfoModel: HJModel, MineInfoModelAdapt {
    
    var height: CGFloat {
        return 165
    }
}


protocol MineInfoModelAdapt {
    
    var height: CGFloat { get }
}
