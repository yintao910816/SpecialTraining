//
//  Home.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

//MARK:
//MARK: 体验专区
class ExperienceCourseModel: HJModel {
    
    var advertList = [AdvertListModel]()
    
    var courseList = [ExperienceCourseItemModel]()
}

class ExperienceCourseItemModel: BaseCourseModel {
    
    var course_id: String = ""
    var pic: String = ""
    var about_price: String = ""

}

extension ExperienceCourseItemModel {
    
    var size: CGSize {
        get {
            let width: CGFloat = (PPScreenW - sectionInset.left - sectionInset.right - minimumInteritemSpacing) / 2.0
            let height: CGFloat = width + courseDisplayMinuteCellBottomHeight
            return .init(width:  width, height: height)
        }
    }
    
    override var minimumLineSpacing: CGFloat {
        get {
            return 5
        }
    }
    
    override var minimumInteritemSpacing: CGFloat {
        get {
            return 7
        }
    }

}

//MARK:
//MARK: 附近机构
class NearByOrganizationModel: HJModel {
    
    var advertList = [AdvertListModel]()
    
    var agnList = [NearByOrganizationItemModel]()
    
    class func testData() ->NearByOrganizationModel {
        let m = NearByOrganizationModel()
        m.advertList = [AdvertListModel(), AdvertListModel()]
        m.agnList    = [NearByOrganizationItemModel(), NearByOrganizationItemModel()]
        return m
    }
}

class NearByOrganizationItemModel: HJModel {
/**
     "agn_id": 14,
     "agn_name": "优培训14",
     "logo": "http://images.youpeixunjiaoyu.com/test/agn.png",
     "motto": "我于杀戮之中绽放，亦如黎明中的花朵",
     "introduce": "机构简介机构简介机构简介机构简介机构简介机构简介",
     "label": "中国舞 拉丁舞 街舞"

     */
    var agn_id: String = ""
    var agn_name: String = ""
    var logo: String = ""
    var motto: String = ""
    var introduce: String = ""
    var label: String = ""
    
    var shops = [ShopModel]()
}

class ShopModel: HJModel {
    
    var shop_id: String = ""
    var shop_name: String = ""
    var logo: String = ""
    var lat: String = ""
    var lng: String = ""
    var dis: String = ""
    
}

//MARK:
//MARK: 附近课程
class NearByCourseModel: BaseCourseModel {
    var advertList = [AdvertListModel]()
    
    var nearCourseList = [NearByCourseItemModel]()
}

class NearByCourseItemModel: BaseCourseModel {
    
    var shop_id: String = ""
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
    var status: Int = 0
    var createtime: String = ""
    var shop_name: String = ""
    var dis: String = ""
}

extension NearByCourseItemModel {
    
    var size: CGSize {
        get {
            return .init(width: PPScreenW - sectionInset.left - sectionInset.right, height: courseListCellHeight)
        }
    }
}

class AdvertListModel: HJModel {

    var adv_id: Int = 0
    var adv_title: String = ""
    var adv_image: String = ""
    var adv_url: String = ""
    var createtime: String = ""
}

extension AdvertListModel: CarouselSource {
    
    var url: String? {
        return adv_image
    }
}

class HomeNearbyCourseModel: HJModel {
    var advertList: [AdvertListModel] = []
    var nearCourseList: [NearCourseListModel] = []
}

class NearCourseListModel: HJModel {
    var shop_id: String = ""
    var shop_name: String = ""
    var shop_logo: String = ""
    var dis: String = ""

    var course: [HomeNearbyCourseItemModel] = []
}

class HomeNearbyCourseItemModel: BaseCourseModel {
    var course_id: String = ""
    var title: String = ""
    var about_price: String = ""
    var introduce: String = ""
    
    // 第一个cell所需要的参数
    var shop_id: String = ""
    var shop_name: String = ""
    var shop_logo: String = ""
    var dis: String = ""

    var showCellImg: Bool = false
    var cellHeight: CGFloat = 100
}

extension HomeNearbyCourseItemModel {
    
    var size: CGSize {
        get {
            let width: CGFloat = PPScreenW - sectionInset.left - sectionInset.right - minimumInteritemSpacing
            let height: CGFloat = showCellImg ? 100 : 80
            return .init(width:  width, height: height)
        }
    }
    
    override var minimumLineSpacing: CGFloat {
        get {
            return 0
        }
    }
    
    override var minimumInteritemSpacing: CGFloat {
        get {
            return 0
        }
    }
    
}

