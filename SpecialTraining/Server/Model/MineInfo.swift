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
        return (title == "头像" || title == "学员照片") ? 80 : 45
    }
}

class StudentInfoModel: HJModel, MineInfoModelAdapt {
    
    var height: CGFloat {
        return 81
    }
}


protocol MineInfoModelAdapt {
    
    var height: CGFloat { get }
}


class MyAddressModel: HJModel {
    var address: String = ""
    
    var placholdText: String = ""
    var title: String = ""
    
    class func testData() ->[MyAddressModel] {
        var data = [MyAddressModel]()
        for idx in 1..<4 {
            let model = MyAddressModel()
            model.address = "我的第\(idx)地址"
            data.append(model)
        }
        return data
    }
    
    class func testEditAddressModel() ->[MyAddressModel] {
        var data = [MyAddressModel]()
        var titles = ["联系人姓名", "手机号码", "详细地址"]
        var placholdTexts = ["请输入联系人姓名", "请输入手机号码", "请输入详细地址"]
        for idx in 0..<3 {
            let model = MyAddressModel()
            model.title = titles[idx]
            model.placholdText = placholdTexts[idx]
            data.append(model)
        }
        return data
    }
}
