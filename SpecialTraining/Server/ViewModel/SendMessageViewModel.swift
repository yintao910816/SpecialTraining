//
//  SendMessageViewModel.swift
//  SpecialTraining
//
//  Created by xujun on 2018/12/18.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SendMessageViewModel: BaseViewModel,VMNavigation {
    
    init(tap: Driver<Void>, authCode: Driver<String>, next: Driver<Void>, phone: String) {
        super.init()
        
        tap.drive(onNext: {
            STProvider.request(.sendCode(mobile: phone))
                .subscribe(onSuccess: { [weak self] (_) in
                    
                }, onError: { [weak self] (error) in
                    self?.hud.failureHidden(self?.errorMessage(error))
                })
        }).disposed(by: disposeBag)
        
        next.withLatestFrom(authCode)
            .filter { [unowned self] (code) -> Bool in
                if code.count > 0 {
                    return true
                }
                self.hud.failureHidden("请输入验证码")
                return false
        }
        .asDriver()
        ._doNext(forNotice: hud)
            .drive(onNext: { (code) in
                SendMessageViewModel.sbPush("STLogin", "setnewPwd", bundle: Bundle.main, parameters: ["phone":phone,"code":code])
            }).disposed(by: disposeBag)
    }
    
}

