//
//  ContactsViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/15.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class ContactsViewModel: BaseViewModel {
    
    var listDataSource = Variable([ContactsModel]())
    
    override init() {
        super.init()
        
        let testModel = ContactsModel()
        testModel.title = "申请与通知"
        listDataSource.value = [testModel]
        
        EMClient.shared()?.contactManager.getContactsFromServer(completion: { (data, error) in
            PrintLog(data)
        })
    }
}
