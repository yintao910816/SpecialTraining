//
//  CourseClass.swift
//  SpecialTraining
//
//  Created by sw on 27/06/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import HandyJSON
import SQLite
import RxSwift

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
    /// 班级封面
    var class_pic: String = ""
    var teacher_name: String = ""
    var class_category: String = ""
    /// 课程封面
    var course_pic: String = ""

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
    
    /// 班级详情界面使用
    var showChange: Bool = false
    var hasVideo: Bool = false
    var lessonName: String = ""
    
    /// 购买班级所属用户
    var uid: String = ""
    
    override func mapping(mapper: HelpingMapper) {
        //        mapper.specify(property: &pic, name: "class_pic")
        //        mapper.specify(property: &pic, name: "pic")
        mapper <<< course_pic <-- ["pic"]
    }
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
        static let classPicEx = Expression<String>("classPic")
        static let teacher_nameEx = Expression<String>("teacher_name")
        static let class_categoryEx = Expression<String>("class_category")
        
        static let coursePicEx = Expression<String>("coursePic")
        
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
        builder.column(ExpressionEx.classPicEx)
        builder.column(ExpressionEx.teacher_nameEx)
        builder.column(ExpressionEx.class_categoryEx)
        builder.column(ExpressionEx.coursePicEx)

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
                            model.class_pic = row[ExpressionEx.classPicEx]
                            model.teacher_name = row[ExpressionEx.teacher_nameEx]
                            model.class_category = row[ExpressionEx.class_categoryEx]
                            model.course_pic = row[ExpressionEx.coursePicEx]

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

            DBQueue.share.selectQueues(classIds,
                                       courseOrderTB,
                                       expression: ExpressionEx.class_idEx,
                                       CourseDetailClassModel.self,
                                       complement:
                { table in
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
                            model.class_pic = row[ExpressionEx.classPicEx]
                            model.teacher_name = row[ExpressionEx.teacher_nameEx]
                            model.class_category = row[ExpressionEx.class_categoryEx]
                            model.course_pic = row[ExpressionEx.coursePicEx]
                            
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
        tempSetters.append(ExpressionEx.classPicEx <- model.class_pic)
        tempSetters.append(ExpressionEx.teacher_nameEx <- model.teacher_name)
        tempSetters.append(ExpressionEx.class_categoryEx <- model.class_category)
        tempSetters.append(ExpressionEx.coursePicEx <- model.course_pic)

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
        tempSetters.append(ExpressionEx.classPicEx <- model.class_pic)
        tempSetters.append(ExpressionEx.teacher_nameEx <- model.teacher_name)
        tempSetters.append(ExpressionEx.class_categoryEx <- model.class_category)
        tempSetters.append(ExpressionEx.coursePicEx <- model.course_pic)

        tempSetters.append(ExpressionEx.shop_idEx <- shopModel.shop_id)
        tempSetters.append(ExpressionEx.shop_nameEx <- shopModel.shop_name)
        tempSetters.append(ExpressionEx.titleEx <- shopModel.shop_name)
        
        tempSetters.append(ExpressionEx.uidEx <- "\(userDefault.uid)")
        
        return tempSetters
    }
    
}
