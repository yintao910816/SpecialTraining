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
class ExperienceCourseModel: NearByCourseModel {
    
}

extension ExperienceCourseModel {
    
    override var size: CGSize {
        get {
            let width: CGFloat = (PPScreenW - sectionInset.left - sectionInset.right - minimumInteritemSpacing) / 2.0
            let height: CGFloat = width * 3 / 4
            return .init(width:  width, height: height)
        }
    }

}

//MARK:
//MARK: 附近课程
class NearByCourseModel: BaseCourseModel {
    var course_id: String = ""
    var agn_id: String = ""
    var title: String = ""
    var pic: String = ""
    var about_price: String = ""
    var introduce: String = ""
    var content: String = ""
    var type_id: String = ""
    var type_name: String = ""
    var status: Int = 0
    var remark: String = ""
    var sort: Int = 0
    var flag: String = ""
    var is_activity: String = ""
    var sales: Int = 100
    var createtime: String = ""
    var updatetime: String = ""
    
    var shop_id: String = ""
    var shop_name: String = ""
    var dis: String = ""
}

extension NearByCourseModel {
    
    var size: CGSize {
        get {
            return .init(width: PPScreenW - sectionInset.left - sectionInset.right, height: courseListCellHeight)
        }
    }
}

//MARK:
//MARK: 为你优选
class OptimizationCourseModel: BaseCourseModel {
    
}

extension OptimizationCourseModel {
    
    var size: CGSize {
        get {
            let width: CGFloat = (PPScreenW - sectionInset.left - sectionInset.right - minimumInteritemSpacing) / 2.0
            let height: CGFloat = width + courseDisplayMinuteCellBottomHeight
            return .init(width:  width, height: height)
        }
    }
}
