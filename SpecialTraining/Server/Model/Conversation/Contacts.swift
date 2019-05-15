//
//  Contacts.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/15.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation

class ContactsModel {
    var icon: UIImage?
    var title: String = ""
}

//MARK:
//MARK: 好友申请列表
class AddFriendsModel {
    var fromUser: String = ""
    var toUser: String = ""
    var isAdd: Bool = true
}

import SQLite
import RxSwift

extension AddFriendsModel: DBOperation {
    
    struct ExpressionEx {
        static let idEx = Expression<Int64>("id")
        static let fromUserEx = Expression<String>("fromUser")
        static let toUserEx   = Expression<String>("toUser")
        static let isAddEx   = Expression<Bool>("isAdd")

    }
    

    static func dbBind(_ builder: TableBuilder) {
        builder.column(ExpressionEx.idEx, primaryKey: true)
        builder.column(ExpressionEx.fromUserEx)
    }
    
    static func inster(with fromUser: String, complement: (()->())? = nil) {
        let currentUser = UserAccountServer.share.loginUser.member.mob
        
        let entity = AddFriendsModel()
        entity.fromUser = fromUser
        entity.toUser   = currentUser
        
        DBQueue.share.insterOrUpdateQueue((ExpressionEx.fromUserEx == fromUser && ExpressionEx.toUserEx == currentUser),
                                          config(setters: entity),
                                          addFriendsApplyTB,
                                          UserInfoModel.self)
        {
            complement?()
        }
    }
    
    static func delete(with aformUser: String) {
        let currentUser = UserAccountServer.share.loginUser.member.mob

        DBQueue.share.deleteRowQueue((ExpressionEx.fromUserEx == aformUser && ExpressionEx.toUserEx == currentUser),
                                     addFriendsApplyTB,
                                     AddFriendsModel.self)
    }
    
    static func slectedApplys() -> Observable<[AddFriendsModel]>{
        return Observable<[AddFriendsModel]>.create({ obser -> Disposable in
            let currentUser = UserAccountServer.share.loginUser.member.mob

            DBQueue.share.selectQueue(ExpressionEx.toUserEx == currentUser,
                                      addFriendsApplyTB,
                                      AddFriendsModel.self,
                                      complement: { table in
                guard let query = table else {
                    obser.onNext([AddFriendsModel]())
                    obser.onCompleted()
                    return
                }

                do {
                    guard let rows = try db?.prepare(query) else {
                        obser.onNext([AddFriendsModel]())
                        obser.onCompleted()
                        return
                    }
                    var datas = [AddFriendsModel]()
                    for row in rows {
                        let m = AddFriendsModel()
                        m.fromUser = row[ExpressionEx.fromUserEx]
                        datas.append(m)
                    }
                    obser.onNext(datas)
                    obser.onCompleted()
                }catch {
                    obser.onNext([AddFriendsModel]())
                    obser.onCompleted()
                }

            })
            return Disposables.create()
        })
    }

    
    private static func config(setters model: AddFriendsModel) ->[Setter] {
        var tempSetters = [Setter]()
        tempSetters.append(ExpressionEx.fromUserEx <- model.fromUser)
        tempSetters.append(ExpressionEx.toUserEx <- model.toUser)
        tempSetters.append(ExpressionEx.isAddEx <- model.isAdd)

        return tempSetters
    }

}
