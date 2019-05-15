//
//  AddFriendsViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/15.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxCocoa

class AddFriendsViewModel: BaseViewModel {
    
    
    
    init(searchTap: Driver<Void>, searchText: Driver<String>) {
        super.init()
        
        searchTap.withLatestFrom(searchText)
            .filter{ userName in
                if userName.count > 0 {
                    return true
                }
                NoticesCenter.alert(message: "请输入用户名")
                return false
            }
            ._doNext(forNotice: hud)
            .drive(onNext: { [weak self] userName in
                EMClient.shared()?.contactManager.addContact(userName, message: "请求添加好友", completion: { (msg, error) in
                    if let err = error {
                        self?.hud.failureHidden(err.errorDescription)
                    }else {
                        self?.hud.successHidden("添加成功")
                    }
                })
            })
            .disposed(by: disposeBag)
    }
}
