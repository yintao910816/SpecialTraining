//
//  Organization.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation


//MARK:
//MARK: 活动介绍
class ActivityBrefModel: HJModel {
    
    var adv_id: String = ""
    var adv_title: String = ""
    var adv_image: String = ""
    var adv_url: String = ""
    var createtime: String = ""
    
    static var cellHeight: CGFloat = 231.0
}

//MARK:
//MARK: 推荐课程
class RecommendCourseModel: HJModel {
    
    var course_id: String = ""
    var agn_id: String = ""
    var title: String = ""
    var pic: String = ""
    var about_price: String = ""
    var introduce: String = ""
    var content: String = ""
    var type_id: String = ""
    var type_name: String = ""
    var flag: String = ""
    var createtime: String = ""
    var status: Int = 0

    static var cellHeight: CGFloat = 330.0

}

//MARK:
//MARK: 老师风采
class TeachersModel: HJModel {
        
    var teacher_id: String = ""
    var teacher_name: String = ""
    var pic: String = ""
    var introduce: String = ""
    
    var pic_width: String = "0"
    var pic_high: String  = "0"
    
    lazy var imgShowHeight: CGFloat = {
        let scale: Double = Double(self.pic_high)! / Double(self.pic_width)!
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
    
    var item: VideoCateListModel = VideoCateListModel()
    var isSelected: Bool = false
    
    class func creatModels() ->[ChoseClassificationModel] {
        var models = [ChoseClassificationModel]()
        for item in STHelper.share.videoCates {
            let m = ChoseClassificationModel()
            m.item = item
            models.append(m)
        }
        return models
    }
}

//MARK:
//MARK: 机构详情
class AgencyDetailModel: HJModel {
    var advList: AgencyDetailAdvListModel = AgencyDetailAdvListModel()
    var agn_info: AgnDetailInfoModel = AgnDetailInfoModel()
    var courseList: [AgnDetailCourseListModel] = []
}

class AgencyDetailAdvListModel: HJModel {
    var AI: [AgencyDetailAdvModel] = []
    var AC: [AgencyDetailAdvModel] = []
    var AT: [AgencyDetailAdvModel] = []
    var AS: [AgencyDetailAdvModel] = []
}

class AgencyDetailAdvModel: HJModel {
    var adv_id: String = ""
    var adv_title: String = ""
    var adv_image: String = ""
    var adv_url: String = ""
    var adv_type: String = ""
}

extension AgencyDetailAdvModel: CarouselSource {
    var url: String?{ return self.adv_image }
}

class AgnDetailCourseListModel: HJModel {
    var course_id: String = ""
    var agn_id: String = ""
    var title: String = ""
    var pic: String = ""
    var about_price: String = ""
    var label: String = ""
    var introduce: String = ""
    var content: String = ""
    var type_id: String = ""
    var type_name: String = ""
    var flag: String = ""
    var status: Int = 1
}

import HandyJSON
/// 机构详情师资
class AgnDetailTeacherModel: HJModel {
    var teacher_id: String = ""
    var teacher_name: String = ""
    var pic: String = ""
    var introduce: String = ""
    
    var pic_high: String = "400"
    var pic_width: String = "300"

    lazy var imgShowHeight: CGFloat = {
        let scale: Double = Double(self.pic_high)! / Double(self.pic_width)!
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


/// 机构 ->所有店铺
class OrganzationModel: HJModel {
    var agn_info: AgnDetailInfoModel = AgnDetailInfoModel()
    var advList: [AgencyDetailAdvModel] = [AgencyDetailAdvModel]()
    var shopList: [OrganazitonShopModel] = [OrganazitonShopModel]()
}

class AgnDetailInfoModel: HJModel {
    var agn_id: String = ""
    var agn_name: String = ""
    var logo: String = ""
    var top_pic: String = ""
    var motto: String = ""
    var introduce: String = ""
    var content: String = ""
    var label: String = ""
    var mob: String = ""
    var address: String = ""
    var license_pic: String = ""
    var idcard_a: String = ""
    var idcard_b: String = ""
    var reg_num: String = ""
    var createtime: String = ""
    var check_truth: String = ""
    var status: Int = 1
}

class OrganazitonShopModel: HJModel {
    var shop_id: String = ""
    var agn_id: String = ""
    var shop_name: String = ""
    var logo: String = ""
    var agnShopDescription: String = ""
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
    var dis: String = ""
    
    var picList: [OrganazitonPicModel] = [OrganazitonPicModel]()
    
    override func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &agnShopDescription, name: "description")
    }
}

class OrganazitonPicModel: HJModel {
    var id: String = ""
    var shop_id: String = ""
    var category_id: String = ""
    var category_name: String = ""
    var shop_pic: String = ""
}


//MARK:
//MARK: 店铺详情数据

/// 店铺详情
class ShopDetailModel: HJModel {
    var op_id: String = ""
    var agn_id: String = ""
    var shop_name: String = ""
    var logo: String = ""
    var descriptionText: String = ""
    var content: String = ""
    var contact: String = ""
    var label: String = ""
    var tel: String = ""
    var mob: String = ""
    var address: String = ""
    var work_time: String = ""
    var lng: String = ""
    var lat: String = ""
    var createtime: String = ""
    var check_truth: String = ""
    var status: String = ""

    var picList: [String] = []
    
    var teachers: [ShopDetailTeacherModel] = []
    var advList: [ShopDetailAdvModel] = []
    var course: [ShopDetailCourseModel] = []
    
    override func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &descriptionText, name: "description")
    }
}

/// 店铺详情 - 课程轮播图
class ShopDetailAdvModel: HJModel {
    var adv_id: String = ""
    var adv_title: String = ""
    var adv_image: String = ""
    var adv_url: String = ""
    var adv_type: String = ""
}

extension ShopDetailAdvModel: CarouselSource {
    
    var url: String? { return adv_image }
}

/// 店铺详情 - 师资
class ShopDetailTeacherModel: HJModel {

    var teacher_id: String = ""
    var teacher_name: String = ""
    var introduce: String = ""
    var pic: String = ""
    var teacher_level: String = ""
    var pic_width: NSNumber = NSNumber.init(value: 0)
    var pic_high: NSNumber = NSNumber.init(value: 0)

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

/// 店铺详情 - 课程
class ShopDetailCourseModel: HJModel {
    var course_id: String = ""
    var shop_id: String = ""
    var title: String = ""
    var pic: String = ""
    var about_price: String = ""
    var label: String = ""
    var introduce: String = ""
    var content: String = ""
    var pic_list: String = ""
    var type_id: String = ""
    var type_name: String = ""
    var flag: String = ""
    var createtime: String = ""
    var status: String = ""
}
