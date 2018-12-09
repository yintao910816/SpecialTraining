//
//  Organization.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation

class OrganizationModel: HJModel {
    
}

//MARK:
//MARK: 实体店
class PhysicalStoreModel: HJModel {
    
    static var cellHeight: CGFloat = 184.0
}

//MARK:
//MARK: 活动介绍
class ActivityBrefModel: HJModel {
    
    static var cellHeight: CGFloat = 261.0

}

//MARK:
//MARK: 推荐课程
class RecommendCourseModel: HJModel {
    
    static var cellHeight: CGFloat = 330.0

}

//MARK:
//MARK: 老师风采
class TeachersModel: HJModel {
    
    // 图片显示尺寸
    var imgWidth: CGFloat = (PPScreenW - 30) / 2.0
    var imgHeight: CGFloat = 0
    
    // cell 尺寸
    var width: CGFloat = (PPScreenW - 30) / 2.0
    var height: CGFloat = 0
    
    class func creatModel(imgW: CGFloat, imgH: CGFloat) ->TeachersModel {
        let m = TeachersModel()
        // 计算图片显示高度
        m.imgHeight = imgH * m.imgWidth / imgW
        // 计算cell高度
        m.height = m.imgHeight + TeachersCell.withoutImageHeight
        return m
    }
    
}

// 发布视屏，机构选择
class ChoseOrganizationModel: HJModel {
    
    var name: String = ""
    var isSelected: Bool = false
    
    class func testCreatModels() ->[ChoseOrganizationModel] {
        var models = [ChoseOrganizationModel]()
        let names = ["荆州艺霖舞蹈迎宾路店", "荆州艺霖舞蹈绿地店", "荆州艺霖舞蹈恒大店"]
        for name in names {
            let m = ChoseOrganizationModel()
            m.name = name
            models.append(m)
        }
        return models
    }
}

// 发布视屏，分类选择
class ChoseClassificationModel: HJModel {
    
    var name: String = ""
    var isSelected: Bool = false
    
    class func testCreatModels() ->[ChoseClassificationModel] {
        var models = [ChoseClassificationModel]()
        let names = ["音乐", "舞蹈", "创意", "手工", "戏曲", "语言", "考级", "会计", "英语", "武术", "播音", "教师"]
        for name in names {
            let m = ChoseClassificationModel()
            m.name = name
            models.append(m)
        }
        return models
    }
}
