//
//  User.swift
//  SpecialTraining
//
//  Created by sw on 25/01/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import HandyJSON
import SQLite
import RxSwift

class LoginModel: HJModel {

    var access_token: String = ""
    var expires_time: Int64 = 0
    var refresh_expires_time: Int64 = 0
    var refresh_token: String = ""
    
    var member: UserInfoModel!
}

class UserInfoModel: HJModel {
    var code: String = ""
    var createtime: String = ""
    var headimgurl: String = ""
    var uid: Int32 = 0
    var mob: String = ""
    var mp_openid: String = ""
    var nickname: String = ""
    var op_openid: String = ""
    var parent_id: String = ""
    var pid: String = ""
    var pwd: String = ""
    var sex: String = ""
    
    override func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &uid, name: "id")
    }
    
    public var isBindPhone: Bool {
        get {
            return mob.count > 0
        }
    }
}

extension UserInfoModel: DBOperation {
    
    struct ExpressionEx {
        static let idEx = Expression<Int64>("id")
        static let access_tokenEx = Expression<String>("access_token")
        static let expires_timeEx = Expression<Int64>("expires_time")
        static let refresh_expires_timeEx = Expression<Int64>("refresh_expires_time")
        static let refresh_tokenEx = Expression<String>("refresh_token")
        static let codeEx = Expression<String>("code")
        static let createtimeEx = Expression<String>("createtime")
        static let headimgurlEx = Expression<String>("headimgurl")
        static let uidEx = Expression<Int64>("uid")
        static let mobEx = Expression<String>("mob")
        static let mp_openidEx = Expression<String>("mp_openid")
        static let nicknameEx = Expression<String>("nickname")
        static let op_openidEx = Expression<String>("op_openid")
        static let parent_idEx = Expression<String>("parent_id")
        static let pidEx = Expression<String>("pid")
        static let pwdEx = Expression<String>("pwd")
        static let sexEx = Expression<String>("sex")
    }
    
    static func dbBind(_ builder: TableBuilder) {
        builder.column(ExpressionEx.idEx, primaryKey: true)
        builder.column(ExpressionEx.access_tokenEx)
        builder.column(ExpressionEx.expires_timeEx)
        builder.column(ExpressionEx.refresh_expires_timeEx)
        builder.column(ExpressionEx.refresh_tokenEx)
        builder.column(ExpressionEx.codeEx)
        builder.column(ExpressionEx.createtimeEx)
        builder.column(ExpressionEx.headimgurlEx)
        builder.column(ExpressionEx.uidEx)
        builder.column(ExpressionEx.mobEx)
        builder.column(ExpressionEx.mp_openidEx)
        builder.column(ExpressionEx.nicknameEx)
        builder.column(ExpressionEx.op_openidEx)
        builder.column(ExpressionEx.parent_idEx)
        builder.column(ExpressionEx.pidEx)
        builder.column(ExpressionEx.pwdEx)
        builder.column(ExpressionEx.sexEx)
    }

    static func inster(user loginInfo: LoginModel) {
        DBQueue.share.insterOrUpdateQueue(ExpressionEx.uidEx == Int64(loginInfo.member.uid),
                                          config(setters: loginInfo),
                                          courseOrderTB,
                                          CourseClassModel.self)
    }
    
    static func slectedLoginUser() -> Observable<LoginModel>{
        return Observable<LoginModel>.create({ obser -> Disposable in
            DBQueue.share.selectQueue(ExpressionEx.uidEx != 0,
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


    private static func config(setters model: LoginModel) ->[Setter] {
        var tempSetters = [Setter]()
        tempSetters.append(ExpressionEx.access_tokenEx <- model.access_token)
        tempSetters.append(ExpressionEx.expires_timeEx <- model.expires_time)
        tempSetters.append(ExpressionEx.refresh_expires_timeEx <- model.refresh_expires_time)
        tempSetters.append(ExpressionEx.refresh_tokenEx <- model.refresh_token)
        tempSetters.append(ExpressionEx.codeEx <- model.member.code)
        tempSetters.append(ExpressionEx.createtimeEx <- model.member.createtime)
        tempSetters.append(ExpressionEx.headimgurlEx <- model.member.headimgurl)
        tempSetters.append(ExpressionEx.uidEx <- Int64(model.member.uid))
        tempSetters.append(ExpressionEx.mobEx <- model.member.mob)
        tempSetters.append(ExpressionEx.mp_openidEx <- model.member.mp_openid)
        tempSetters.append(ExpressionEx.nicknameEx <- model.member.nickname)
        tempSetters.append(ExpressionEx.op_openidEx <- model.member.op_openid)
        tempSetters.append(ExpressionEx.parent_idEx <- model.member.parent_id)
        tempSetters.append(ExpressionEx.pidEx <- model.member.pid)
        tempSetters.append(ExpressionEx.pwdEx <- model.member.pwd)
        tempSetters.append(ExpressionEx.sexEx <- model.member.sex)

        return tempSetters
    }

}
