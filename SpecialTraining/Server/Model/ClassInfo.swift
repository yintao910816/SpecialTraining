//
//  ClassInfo.swift
//  SpecialTraining
//
//  Created by yintao on 2019/4/25.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation

class ClassDataModel: HJModel {
    var shop_info: ShopInfoModel = ShopInfoModel()
    var lessonList: [ClassListModel] = []
    var class_info = CourseDetailClassModel()
    var video_list: [CourseDetailVideoModel] = []
}

class ShopInfoModel: HJModel {
    var shop_id: String = ""
    var shop_name: String = ""
    var address: String = ""
    var mob: String = ""
}

class ClassListModel: HJModel {
    var lesson_id: String = ""
    var lesson_type: String = ""
    var lesson_title: String = ""
    var lesson_time: String = ""
    var name: String = ""
    
    var typeText: String {
        get {
            return lesson_type == "B" ? "备" : "作"
        }
    }
    
    var mainColor: UIColor {
        get {
            return lesson_type == "B" ? RGB(2243, 153, 92) : RGB(37, 167, 250)
        }
    }
    
    lazy var cellHeight: CGFloat = {
        var h: CGFloat = 58 + 15
        let w: CGFloat = PPScreenW - 15 - 35 - 15 - 15
        h += self.lesson_title.getTextHeigh(fontSize: 13, width: w)
        return h
    }()
}

//class ClassDetailVideoModel: HJModel {
//    var res_id: String = ""
//    var course_id: String = ""
//    var shop_id: String = ""
//    var class_id: String = ""
//    var res_type: String = ""
//    var res_title: String = ""
//    var res_image: String = ""
//    var video_id: String = ""
//    var res_url: String = ""
//    var createtime: String = ""
//    var status: Int = 1
//}

//MARK:
//MARK: 我的班级
class MyClassModel: HJModel {
    var class_id: String = ""
    var class_name: String = ""
    var introduce: String = ""
    var suit_peoples: String = ""
    var describe: String = ""
    var class_days: String = ""
    var price: String = ""
    var commission: String = ""
    var createtime: String = ""
    var status: String = ""
//    var lessonList: String = ""
    
    var levelString: String = "0"
}

// 班级详情轮播图
class ClassDetailCarouselModel: CarouselSource {
    var coverURL: String = ""
    
    var url: String? { return coverURL }
    
    class func createData(source: [String]) ->[ClassDetailCarouselModel] {
        var datas = [ClassDetailCarouselModel]()
        for item in source {
            let m = ClassDetailCarouselModel()
            m.coverURL = item
            datas.append(m)
        }
        return datas
    }
}
