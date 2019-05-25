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

class CourseDetailInfoModel: HJModel {
    var shop_name: String = ""
    var mob: String = ""
    var course_id: String = ""
    var shop_id: String = ""
    var title: String = ""
    var pic: String = ""
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

//MARK:
//MARK: 班级
class CourseDetailClassModel: HJModel {
    var class_id: String = ""
    var class_name: String = ""
    var introduce: String = ""
    var suit_peoples: String = ""
    var describe: String = ""
    var class_days: String = ""
    var price: String = ""
    var createtime: String = ""
    var status: String = ""
    var teacher_id: String = ""
    var pic: String = ""
    var teacher_name: String = ""
    var class_category: String = ""
    
    /// 店铺信息
    var shop_id: String = ""
    var shop_name: String = ""
    var title: String = ""

    /// 商品总数
    var count: Int = 1
    /// 商品数量变成1的次数  为2时不能再改变总价
    var countOne: Int = 1
    /// 通过点击+ - 计算好的价格，总数计算时只需正常加减此值
    var calculatePrice: Double = 0.0
    
    var isSelected: Bool = false
    var isLasstRow: Bool = false
    
    /// 购买班级所属用户
    var uid: String = ""
}

extension CourseDetailClassModel: DBOperation {
    
    struct ExpressionEx {
        static let idEx = Expression<Int64>("id")
        static let class_idEx = Expression<String>("class_id")
        static let class_nameEx = Expression<String>("class_name")
        static let introduceEx = Expression<String>("introduce")
        static let suit_peoplesEx = Expression<String?>("suit_peoples")
        static let describeEx = Expression<String>("describe")
        static let class_daysEx = Expression<String>("class_days")
        static let priceEx = Expression<String>("price")
        static let createtimeEx = Expression<String>("createtime")
        static let statusEx = Expression<String>("status")
        static let teacher_idEx = Expression<String>("teacher_id")
        static let picEx = Expression<String>("pic")
        static let teacher_nameEx = Expression<String>("teacher_name")
        static let class_categoryEx = Expression<String>("class_category")
        
        static let shop_idEx = Expression<String>("shop_id")
        static let shop_nameEx = Expression<String>("shop_name")
        static let titleEx = Expression<String>("title")
        
        static let uidEx = Expression<String>("uid")
    }
    
    static func dbBind(_ builder: TableBuilder) {
        builder.column(ExpressionEx.idEx, primaryKey: true)
        
        builder.column(ExpressionEx.class_idEx)
        builder.column(ExpressionEx.class_nameEx)
        builder.column(ExpressionEx.introduceEx)
        builder.column(ExpressionEx.suit_peoplesEx)
        builder.column(ExpressionEx.describeEx)
        builder.column(ExpressionEx.class_daysEx)
        builder.column(ExpressionEx.priceEx)
        builder.column(ExpressionEx.createtimeEx)
        builder.column(ExpressionEx.statusEx)
        builder.column(ExpressionEx.teacher_idEx)
        builder.column(ExpressionEx.picEx)
        builder.column(ExpressionEx.teacher_nameEx)
        builder.column(ExpressionEx.class_categoryEx)
        
        builder.column(ExpressionEx.shop_idEx)
        builder.column(ExpressionEx.shop_nameEx)
        builder.column(ExpressionEx.titleEx)
        
        builder.column(ExpressionEx.uidEx)
    }
    
    class func inster(classInfo datas: [CourseDetailClassModel], courseDetail: CourseDetailInfoModel) {
        for item in datas {
            let filter = ExpressionEx.class_idEx == item.class_id && ExpressionEx.uidEx == "\(userDefault.uid)"
            DBQueue.share.insterOrUpdateQueue(filter,
                                              config(setters: item, courseDetail: courseDetail),
                                              courseOrderTB,
                                              CourseDetailClassModel.self)
        }
    }
    
    class func inster(classInfo data: CourseDetailClassModel, shopModel: ShopInfoModel) {
        let filter = ExpressionEx.class_idEx == data.class_id && ExpressionEx.uidEx == "\(userDefault.uid)"
        DBQueue.share.insterOrUpdateQueue(filter,
                                          config(setters: data, shopModel: shopModel),
                                          courseOrderTB,
                                          CourseDetailClassModel.self)
    }

    class func remove(classInfo classId: String) {
        let filter = ExpressionEx.class_idEx == classId && ExpressionEx.uidEx == "\(userDefault.uid)"
        DBQueue.share.deleteRowQueue(filter, courseOrderTB, CourseDetailClassModel.self)
    }
    
    class func selectedAllOrderClass() -> Observable<[CourseDetailClassModel]>{
        return Observable<[CourseDetailClassModel]>.create({ obser -> Disposable in
            DBQueue.share.selectQueue(ExpressionEx.uidEx == "\(userDefault.uid)",
                                      courseOrderTB,
                                      CourseDetailClassModel.self,
                                      complement: { table in
                                        
                                        guard let query = table else {
                                            obser.onNext([CourseDetailClassModel]())
                                            obser.onCompleted()
                                            return
                                        }

                                        do {
                                            guard let rows = try db?.prepare(query) else {
                                                obser.onNext([CourseDetailClassModel]())
                                                obser.onCompleted()
                                                return
                                            }
                                            var retModels = [CourseDetailClassModel]()
                                            for row in rows {
                                                let model = CourseDetailClassModel()
                                                model.class_id = row[ExpressionEx.class_idEx]
                                                model.class_name = row[ExpressionEx.class_nameEx]
                                                model.introduce = row[ExpressionEx.introduceEx]
                                                model.suit_peoples = row[ExpressionEx.suit_peoplesEx] ?? ""
                                                model.describe = row[ExpressionEx.describeEx]
                                                model.class_days = row[ExpressionEx.class_daysEx]
                                                model.price = row[ExpressionEx.priceEx]
                                                model.createtime = row[ExpressionEx.createtimeEx]
                                                model.status = row[ExpressionEx.statusEx]
                                                model.teacher_id = row[ExpressionEx.teacher_idEx]
                                                model.pic = row[ExpressionEx.picEx]
                                                model.teacher_name = row[ExpressionEx.teacher_nameEx]
                                                model.class_category = row[ExpressionEx.class_categoryEx]
                                                
                                                model.shop_id = row[ExpressionEx.shop_idEx]
                                                model.shop_name = row[ExpressionEx.shop_nameEx]
                                                model.title = row[ExpressionEx.titleEx]

                                                retModels.append(model)
                                            }
                                            
                                            obser.onNext(retModels)
                                            obser.onCompleted()
                                            
                                        }catch {
                                            obser.onNext([CourseDetailClassModel]())
                                            obser.onCompleted()
                                        }
                                        
            })
            return Disposables.create()
        })
    }
    
    class func selectedOrderClass(classIds: [String]) -> Observable<[CourseDetailClassModel]>{
        return Observable<[CourseDetailClassModel]>.create({ obser -> Disposable in
            var retDatas = [CourseDetailClassModel]()
            for idx in 0..<classIds.count {
                let filter = ExpressionEx.class_idEx == classIds[idx] && ExpressionEx.uidEx == "\(userDefault.uid)"

                DBQueue.share.selectQueue(filter,
                                          courseOrderTB,
                                          CourseDetailClassModel.self,
                                          complement: { table in
                                            
                                            guard let query = table else {
                                                obser.onNext([CourseDetailClassModel]())
                                                obser.onCompleted()
                                                return
                                            }
                                            
                                            do {
                                                guard let rows = try db?.prepare(query) else {
                                                    obser.onNext([CourseDetailClassModel]())
                                                    obser.onCompleted()
                                                    return
                                                }
                                                for row in rows {
                                                    let model = CourseDetailClassModel()
                                                    model.class_id = row[ExpressionEx.class_idEx]
                                                    model.class_name = row[ExpressionEx.class_nameEx]
                                                    model.introduce = row[ExpressionEx.introduceEx]
                                                    model.suit_peoples = row[ExpressionEx.suit_peoplesEx] ?? ""
                                                    model.describe = row[ExpressionEx.describeEx]
                                                    model.class_days = row[ExpressionEx.class_daysEx]
                                                    model.price = row[ExpressionEx.priceEx]
                                                    model.createtime = row[ExpressionEx.createtimeEx]
                                                    model.status = row[ExpressionEx.statusEx]
                                                    model.teacher_id = row[ExpressionEx.teacher_idEx]
                                                    model.pic = row[ExpressionEx.picEx]
                                                    model.teacher_name = row[ExpressionEx.teacher_nameEx]
                                                    model.class_category = row[ExpressionEx.class_categoryEx]
                                                    
                                                    model.shop_id = row[ExpressionEx.shop_idEx]
                                                    model.shop_name = row[ExpressionEx.shop_nameEx]
                                                    model.title = row[ExpressionEx.titleEx]
                                                    
                                                    retDatas.append(model)
                                                    if retDatas.count == classIds.count {
                                                        obser.onNext(retDatas)
                                                        obser.onCompleted()
                                                    }
                                                }
                                            }catch {
                                                obser.onNext([CourseDetailClassModel]())
                                                obser.onCompleted()
                                            }
                                            
                })
            }
            return Disposables.create()
        })
    }


    private class func config(setters model: CourseDetailClassModel, courseDetail: CourseDetailInfoModel) ->[Setter] {
        var tempSetters = [Setter]()
        tempSetters.append(ExpressionEx.class_idEx <- model.class_id)
        tempSetters.append(ExpressionEx.class_nameEx <- model.class_name)
        tempSetters.append(ExpressionEx.introduceEx <- model.introduce)
        tempSetters.append(ExpressionEx.suit_peoplesEx <- model.suit_peoples)
        tempSetters.append(ExpressionEx.describeEx <- model.describe)
        tempSetters.append(ExpressionEx.class_daysEx <- model.class_days)
        tempSetters.append(ExpressionEx.priceEx <- model.price)
        tempSetters.append(ExpressionEx.createtimeEx <- model.createtime)
        tempSetters.append(ExpressionEx.statusEx <- model.status)
        tempSetters.append(ExpressionEx.teacher_idEx <- model.teacher_id)
        tempSetters.append(ExpressionEx.picEx <- model.pic)
        tempSetters.append(ExpressionEx.teacher_nameEx <- model.teacher_name)
        tempSetters.append(ExpressionEx.class_categoryEx <- model.class_category)
        
        tempSetters.append(ExpressionEx.shop_idEx <- courseDetail.shop_id)
        tempSetters.append(ExpressionEx.shop_nameEx <- courseDetail.shop_name)
        tempSetters.append(ExpressionEx.titleEx <- courseDetail.title)

        tempSetters.append(ExpressionEx.uidEx <- "\(userDefault.uid)")

        return tempSetters
    }
    
    private class func config(setters model: CourseDetailClassModel, shopModel: ShopInfoModel) ->[Setter] {
        var tempSetters = [Setter]()
        tempSetters.append(ExpressionEx.class_idEx <- model.class_id)
        tempSetters.append(ExpressionEx.class_nameEx <- model.class_name)
        tempSetters.append(ExpressionEx.introduceEx <- model.introduce)
        tempSetters.append(ExpressionEx.suit_peoplesEx <- model.suit_peoples)
        tempSetters.append(ExpressionEx.describeEx <- model.describe)
        tempSetters.append(ExpressionEx.class_daysEx <- model.class_days)
        tempSetters.append(ExpressionEx.priceEx <- model.price)
        tempSetters.append(ExpressionEx.createtimeEx <- model.createtime)
        tempSetters.append(ExpressionEx.statusEx <- model.status)
        tempSetters.append(ExpressionEx.teacher_idEx <- model.teacher_id)
        tempSetters.append(ExpressionEx.picEx <- model.pic)
        tempSetters.append(ExpressionEx.teacher_nameEx <- model.teacher_name)
        tempSetters.append(ExpressionEx.class_categoryEx <- model.class_category)
        
        tempSetters.append(ExpressionEx.shop_idEx <- shopModel.shop_id)
        tempSetters.append(ExpressionEx.shop_nameEx <- shopModel.shop_name)
        tempSetters.append(ExpressionEx.titleEx <- shopModel.shop_name)
        
        tempSetters.append(ExpressionEx.uidEx <- "\(userDefault.uid)")

        return tempSetters
    }

}
