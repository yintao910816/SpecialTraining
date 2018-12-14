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
 
    class func test() ->[ExperienceCourseModel] {
        var datas = [ExperienceCourseModel]()
        for _ in 0..<5 {
            datas.append(ExperienceCourseModel())
        }
        return datas
    }

}

extension ExperienceCourseModel {
    
    override var size: CGSize {
        get {
            let width: CGFloat = (PPScreenW - sectionInset.left - sectionInset.right - minimumInteritemSpacing) / 2.0
            let height: CGFloat = (width * 3 / 4) + 37
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
    
    class func testDatas() ->[NearByCourseModel] {
        var datas = [NearByCourseModel]()
        for _ in 0..<5 {
            let m = NearByCourseModel()
            m.title = "测试测试"
            m.shop_name = "测试测试"
            m.dis = "测试测试"
            m.content = "测试测试"
            m.about_price = "测试测试"
            datas.append(m)
        }
        return datas
    }
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
