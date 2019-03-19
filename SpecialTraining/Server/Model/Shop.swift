//
//  Shop.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/19.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import HandyJSON

class OrganazitionShopModel: HJModel {
    var shop_id: String = ""
    var agn_id: String = ""
    var shop_name: String = ""
    var logo: String = ""
    var shopDescription: String = ""
    var content: String = ""
    var contact: String = ""
    var label: String = ""
    var tel: String = ""
    var mob: String = ""
    var address: String = ""
    var work_time: String = ""
    var lat: String = ""
    var lng: String = ""
    var createtime: String = ""
    var check_truth: String = ""
    var status: String = ""

    var teachers: [ShopTeacherModel] = [ShopTeacherModel]()
    var advList: [AgencyDetailAdvModel] = [AgencyDetailAdvModel]()
    var course: [ShopCourseModel] = [ShopCourseModel]()
    
    override func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &shopDescription, name: "description")
    }
}

class ShopCourseModel: HJModel {

    var course_id: String = ""
    var shop_id: String = ""
    var title: String = ""
    var pic: String = ""
    var about_price: String = ""
    var label: String = ""
    var introduce: String = ""
    var content: String = ""
    var type_id: String = ""
    var type_name: String = ""
    var flag: String = ""
    var createtime: String = ""
    var status: String = ""
}

class ShopTeacherModel: HJModel {
    var teacher_id: String = ""
    var agn_id: String = ""
    var teacher_name: String = ""
    var teacher_level: String = ""
    var pic: String = ""
    var pic_width: NSNumber = NSNumber.init(value: 300)
    var pic_high: NSNumber = NSNumber.init(value: 400)
    var introduce: String = ""
    var content: String = ""
    var createtime: String = ""
    var status: String = ""
    var id: String = ""
    var shop_id: String = ""

    lazy var imgShowHeight: CGFloat = {
        let h = CGFloat(self.pic_high.floatValue)
        let w = CGFloat(self.pic_width.floatValue)
        let scale: CGFloat = h / w
        return cellWidth * CGFloat(scale)
    }()
    
    lazy var cellWidth: CGFloat = {
        let w = (PPScreenW - 30) / 2.0
        return w
    }()
    
    lazy var cellHeight: CGFloat = {
        return imgShowHeight + TeachersCell.withoutImageHeight
    }()
}

class TeacherDetailModel: HJModel {
    var class_id: String = ""
    var class_name: String = ""
    var class_image: String = ""
    var introduce: String = ""
    var class_days: String = ""
    var price: String = ""
    var createtime: String = ""
    var status: String = ""
}
