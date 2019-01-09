//
//  CourseDetail.swift
//  SpecialTraining
//
//  Created by yintao on 2019/1/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//  课程详情

import Foundation

// banner部分
class CourseDetailBannerModel: HJModel {
    var course_id: String = ""
    var title: String = ""
    var about_price: String = ""
    var introduce: String = ""
    var top_pic: String = ""
    var content: String = ""
}

// 上课时间
class ClassTimeModel: HJModel {
    /// A 高级 B中级 C初级

    var A: [ClassTimeItemModel] = []
    var B: [ClassTimeItemModel] = []
    var C: [ClassTimeItemModel] = []
}

class ClassTimeItemModel: HJModel {
    
    var sch_id: String = ""
    var class_id: String = ""
    var class_level: String = ""
    var teacher_name: String = ""
    var teacher_pic: String = ""
    var start_time: String = ""
    var end_time: String = ""
    var stuTime: String = ""
}


// 上课音频、精彩内容
class CourseDetailMediaModel: HJModel {
    var res_id: String = ""
    var course_id: String = ""
    var class_id: String = ""
    var res_title: String = ""
    var res_image: String = ""
    var res_url: String = ""
    var res_type: String = ""
    var createtime: String = ""
    var status: Int = 0
}


import HandyJSON

// 相关校区
class RelateShopModel: HJModel {

    var shop_id: String = ""
    var agn_id: String = ""
    var shop_name: String = ""
    var logo: String = ""
    var descriptionText: String = ""
    var content: String = ""
    var label: String = ""
    var tel: String = ""
    var address: String = ""
    var lat: String = ""
    var lng: String = ""
    var work_time: String = ""
    var createtime: String = ""
    var check_truth: String = ""
    var dis: String = ""
    var status: Int = 0
    
    override func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &descriptionText, name: "description")
    }
}
