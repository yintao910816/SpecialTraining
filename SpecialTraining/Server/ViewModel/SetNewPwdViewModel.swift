//
//  SetNewPwdViewModel.swift
//  SpecialTraining
//
//  Created by xujun on 2018/12/18.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SetNewPwdViewModel: BaseViewModel {
    
    init(tap: Driver<Void>, pwd: Driver<String>, code: String, phone: String) {
        super.init()
        
        tap.withLatestFrom(pwd).filter { [unowned self] (pwd) -> Bool in
            if pwd.count > 0 {
                return true
            }
            self.hud.failureHidden("密码格式错误")
            return false
        }.asDriver()
        ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] (pwd) in
                self.setnewPwdRequest(mobile: phone, code: code, pswd: pwd)
            }).disposed(by: disposeBag)
    }
    
    func setnewPwdRequest(mobile: String, code: String, pswd: String) {
        STProvider.request(.setPassword(mobile: mobile, code: code, pswd: pswd))
            .subscribe(onSuccess: { [weak self] (_) in
                
            }) { [weak self] (error) in
                
        }
    }
    
}
