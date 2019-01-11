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

/// 获取班级
class CourseClassModel: HJModel {
    /**
     class_id: 1,
     class_name: "拉丁舞初级班",
     class_image: "http://images.youpeixunjiaoyu.com/course/course.png",
     shop_id: 1,
     course_id: 1,
     teacher_id: 1,
     introduce: "拉丁舞拉丁舞拉丁舞拉丁舞",
     content: "优培训-绿地店优培训-绿地店优培训-绿地店优培训-绿地店优培训-绿地店优培训-绿地店优培训-绿地店优培训-绿地店优培训-绿地店优培训-绿地店优培训-绿地店优培训-绿地店优培训-绿地店优培训-绿地店优培训-绿地店",
     price: "1280",
     class_level: "C",
     createtime: "2018-11-17 11:56:24",
     status: 1,
     agn_id: 1,
     teacher_name: "吴安娜",
     teacher_level: "高级拉丁舞教师",
     pic: "http://images.youpeixunjiaoyu.com/course/course.png",
     pic_width: "108",
     pic_high: "138",
     title: "拉丁舞",
     top_pic: "http://images.youpeixunjiaoyu.com/test/agn_top.png",
     about_price: "2200-2800/90节/全年",
     label: "中国舞 拉丁舞 街舞",
     type_id: 1,
     type_name: "拉丁舞",
     flag: "T",
     shop_name: "优培训-中银大厦",
     logo: "logo",
     description: "优培训-绿地店优培训-绿地店优培训-绿地店",
     contact: "张三",
     tel: "8840325",
     mob: "15927791310",
     address: "荆州区火车站222号",
     lat: "112.218148",
     lng: "30.356011",
     check_truth: "Y"

     */
    var class_id: String = ""
    var class_name: String = ""
    var price: String = ""
    var class_image: String = ""
    var teacher_name: String = ""
    var label: String = ""
    var address: String = ""
    var shop_name: String = ""
    
    var introduce: String = ""
    var shop_id: String = ""
    var course_id: String = ""
    var teacher_id: String = ""
    var content: String = ""
    var class_level: String = ""
    var createtime: String = ""
    var teacher_level: String = ""
    /// 商品总数
    var count: Int = 1
    
    var isSelected: Bool = false
    var isLasstRow: Bool = false
}

fileprivate let idEx = Expression<Int64>("id")
fileprivate let class_idEx = Expression<String>("class_id")
fileprivate let class_nameEx = Expression<String>("class_name")
fileprivate let priceEx = Expression<String>("price")
fileprivate let class_imageEx = Expression<String>("class_image")
fileprivate let teacher_nameEx = Expression<String>("teacher_name")
fileprivate let labelEx = Expression<String>("label")
fileprivate let addressEx = Expression<String>("address")
fileprivate let shop_nameEx = Expression<String>("shop_name")
fileprivate let introduceEx = Expression<String>("introduce")
fileprivate let shop_idEx = Expression<String>("shop_id")
fileprivate let course_idEx = Expression<String>("course_id")
fileprivate let teacher_idEx = Expression<String>("teacher_id")
fileprivate let contentEx = Expression<String>("content")
fileprivate let class_levelEx = Expression<String>("class_level")
fileprivate let createtimeEx = Expression<String>("createtime")
fileprivate let teacher_levelEx = Expression<String>("teacher_level")

extension CourseClassModel: DBOperation {
    
    static func dbBind(_ builder: TableBuilder) {
        builder.column(idEx, primaryKey: true)

        builder.column(class_idEx)
        builder.column(class_nameEx)
        builder.column(priceEx)
        builder.column(class_imageEx)
        builder.column(teacher_nameEx)
        builder.column(labelEx)
        builder.column(addressEx)
        builder.column(shop_nameEx)
        builder.column(introduceEx)
        builder.column(shop_idEx)
        builder.column(course_idEx)
        builder.column(teacher_idEx)
        builder.column(contentEx)
        builder.column(class_levelEx)
        builder.column(createtimeEx)
        builder.column(teacher_levelEx)
    }
    
    class func inster(classInfo datas: [CourseClassModel]) {
        for item in datas {
            DBQueue.share.insterOrUpdateQueue(class_idEx == item.class_id,
                                              config(setters: item),
                                              courseOrderTB,
                                              CourseClassModel.self)
        }
    }
    
    class func slectedClassInfo() -> Observable<[CourseClassModel]>{
        return Observable<[CourseClassModel]>.create({ obser -> Disposable in
            DBQueue.share.selectQueue(class_idEx != "",
                                      courseOrderTB,
                                      CourseClassModel.self,
                                      complement: { table in

                                        guard let query = table else {
                                            obser.onNext([CourseClassModel]())
                                            obser.onCompleted()
                                            return
                                        }

                                        do {
                                            guard let rows = try db?.prepare(query) else {
                                                obser.onNext([CourseClassModel]())
                                                obser.onCompleted()
                                                return
                                            }
                                            var retModels = [CourseClassModel]()
                                            for row in rows {
                                                let model = CourseClassModel()
                                                model.class_id = row[class_idEx]
                                                model.class_name = row[class_nameEx]
                                                model.price = row[priceEx]
                                                model.teacher_name = row[teacher_nameEx]
                                                model.label = row[labelEx]
                                                model.address = row[addressEx]
                                                model.shop_name = row[shop_nameEx]
                                                model.introduce = row[introduceEx]
                                                model.shop_id = row[shop_idEx]
                                                model.course_id = row[course_idEx]
                                                model.teacher_id = row[teacher_idEx]
                                                model.content = row[contentEx]
                                                model.class_level = row[class_levelEx]
                                                model.createtime = row[createtimeEx]
                                                model.teacher_level = row[teacher_levelEx]

                                                retModels.append(model)
                                            }
                                            
                                            obser.onNext(retModels)
                                            obser.onCompleted()

                                        }catch {
                                            obser.onNext([CourseClassModel]())
                                            obser.onCompleted()
                                        }
                                        
            })
            return Disposables.create()
        })
    }
    
    private class func config(setters model: CourseClassModel) ->[Setter] {
        var tempSetters = [Setter]()
        tempSetters.append(class_idEx <- model.class_id)
        tempSetters.append(class_imageEx <- model.class_name)
        tempSetters.append(class_nameEx <- model.class_name)
        tempSetters.append(priceEx <- model.price)
        tempSetters.append(teacher_nameEx <- model.teacher_name)
        tempSetters.append(labelEx <- model.label)
        tempSetters.append(addressEx <- model.address)
        tempSetters.append(shop_nameEx <- model.shop_name)
        tempSetters.append(introduceEx <- model.introduce)
        tempSetters.append(shop_idEx <- model.shop_id)
        tempSetters.append(course_idEx <- model.course_id)
        tempSetters.append(teacher_idEx <- model.teacher_id)
        tempSetters.append(contentEx <- model.content)
        tempSetters.append(class_levelEx <- model.class_level)
        tempSetters.append(createtimeEx <- model.createtime)
        tempSetters.append(teacher_levelEx <- model.teacher_level)

        return tempSetters
    }
    
}
