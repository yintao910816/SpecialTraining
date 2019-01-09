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
            if ValidateNum.password(pwd).isRight == false {
                self.hud.failureHidden("请输入正确的密码")
                return false
            }
            return true
        }.asDriver()
        ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] (pwd) in
                self.setnewPwdRequest(mobile: phone, code: code, pswd: pwd)
            }).disposed(by: disposeBag)
    }
    
    func setnewPwdRequest(mobile: String, code: String, pswd: String) {
        STProvider.request(.setPassword(mobile: mobile, code: code, pswd: pswd))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] (_) in
                self?.hud.successHidden("密码设置成功")
                self?.popSubject.onNext(Void())
            }) { [weak self] (error) in
                self?.hud.failureHidden(self?.errorMessage(error))
        }.disposed(by: disposeBag)
    }
    
}
