//
//  CourseDetail.swift
//  SpecialTraining
//
//  Created by yintao on 2019/1/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//  课程详情

import Foundation
import SQLite
import RxSwift

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

class SectionCourseClassModel {
    var shopId: String = ""
    var shopName: String?
    var isSelected: Bool = false
    
    init() {
        
    }
    
    convenience init(shopId: String, shopName: String?) {
        self.init()
        
        self.shopId = shopId
        self.shopName = shopName
    }
}

class CourseDetailModel: HJModel {
    var course_info: CourseDetailInfoModel = CourseDetailInfoModel()
    var videoList: [CourseDetailVideoModel] = []
    var audioList: [CourseDetailAudioModel] = []
    var classList: [CourseDetailClassModel] = []
}

//// 课程详情里面的班级同时存在pic和class_pic，不能使用CourseDetailClassModel
//class CourseDetailClassItemModel: HJModel {
//    var class_category: String = ""
//    var class_days: String = ""
//    var class_id: String = ""
//    var class_name: String = ""
//    var class_pic: String = ""
//    var commission: String = ""
//    var content: String = ""
//    var createtime: String = ""
//    var describe: String = ""
//    var introduce: String = ""
//    var pic: String = ""
//    var price: String = ""
//    var status: String = ""
//    var suit_peoples: String = ""
//    var teacher_id: String = ""
//    var teacher_name: String = ""
//
//    /// 添加字段 - 购买或加入购物车时弹框上班级选择
//    var isSelected: Bool = false
//}

class CourseDetailInfoModel: HJModel {
    var shop_name: String = ""
    var mob: String = ""
    var course_id: String = ""
    var shop_id: String = ""
    var title: String = ""
    var class_pic: String = ""
    var about_price: String = ""
    var label: String = ""
    var introduce: String = ""
    var content: String = ""
    var pic_list: [String] = []
    var type_id: String = ""
    var type_name: String = ""
    var flag: String = ""
    var createtime: String = ""
    var status: String = ""    
}

class CourseDetailHeaderCarouselModel: CarouselSource {
    var pic_url: String = ""
    
    class func creatData(sources: [String]) ->[CourseDetailHeaderCarouselModel] {
        var datas = [CourseDetailHeaderCarouselModel]()
        for item in sources
        {
            let m = CourseDetailHeaderCarouselModel()
            m.pic_url = item
            datas.append(m)
        }
        return datas
    }
    
    var url: String? { return pic_url }
}

class CourseDetailVideoModel: HJModel {
    var res_id: String = ""
    var course_id: String = ""
    var shop_id: String = ""
    var class_id: String = ""
    var res_type: String = ""
    var res_title: String = ""
    var res_image: String = ""
    var res_url: String = ""
    var createtime: String = ""
    var status: String = ""
}

class CourseDetailAudioModel: HJModel {
    var res_id: String = ""
    var course_id: String = ""
    var shop_id: String = ""
    var class_id: String = ""
    var res_type: String = ""
    var res_title: String = ""
    var res_image: String = ""
    var res_url: String = ""
    var createtime: String = ""
    var status: String = ""
}
