//
//  Video.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/17.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

//MARK:
//MARK: 点播
class OndemandModel: HJModel {
    
    var height: CGFloat = 100
    var width: CGFloat = 80
    
    class func creatModel(w: CGFloat, h: CGFloat) ->OndemandModel {
        let m = OndemandModel()
        m.height = h
        m.width  = w
        return m
    }
}

class VideoClassificationModel: HJModel {
    
    var title: String = ""
    var isSelected: Bool = false
    var size: CGSize = .zero
    
    class func creatModel(title: String, selected: Bool = false) ->VideoClassificationModel {
        let m = VideoClassificationModel()
        m.title = title
        m.isSelected = selected
        m.size = .init(width: title.getTexWidth(fontSize: 14, height: 20) + 20, height: 20)
        return m
    }
}
