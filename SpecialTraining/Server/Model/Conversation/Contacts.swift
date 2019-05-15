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
}

import SQLite

extension AddFriendsModel: DBOperation {
    
    struct ExpressionEx {
        static let idEx = Expression<Int64>("id")
        static let fromUserEx = Expression<String>("fromUser")
    }
    

    static func dbBind(_ builder: TableBuilder) {
        builder.column(ExpressionEx.idEx, primaryKey: true)
        builder.column(ExpressionEx.fromUserEx)
    }
    
    static func inster(with fromUser: String) {
        let entity = AddFriendsModel()
        entity.fromUser = fromUser
        
        DBQueue.share.insterOrUpdateQueue(ExpressionEx.fromUserEx == fromUser,
                                          config(setters: entity),
                                          addFriendsApplyTB,
                                          UserInfoModel.self)
    }
    
//    static func delete(with formUser: String) {
//        DBQueue.share.deleteRowQueue(<#T##filier: Expression<Bool>##Expression<Bool>#>, <#T##tbName: String##String#>, <#T##type: DBOperation.Protocol##DBOperation.Protocol#>)
//        DBQueue.share.deleteRowQueue(ExpressionEx.fromUserEx == fromUser, addFriendsApplyTB, AddFriendsModel.self)
//    }
    
    private static func config(setters model: AddFriendsModel) ->[Setter] {
        var tempSetters = [Setter]()
        tempSetters.append(ExpressionEx.fromUserEx <- model.fromUser)
        
        return tempSetters
    }

}
