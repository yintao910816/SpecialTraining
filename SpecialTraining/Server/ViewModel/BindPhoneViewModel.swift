//
//  BindPhoneViewModel.swift
//  SpecialTraining
//
//  Created by xujun on 2018/12/18.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BindPhoneViewModel: BaseViewModel {
    
    init(phone: Driver<String>, code: Driver<String>, sendAuth: Driver<Void>, next: Driver<Void>, op_openid: String) {
        super.init()
        
        sendAuth.withLatestFrom(phone)
            .filter { [unowned self] (phone) -> Bool in
                if ValidateNum.phoneNum(phone).isRight == false {
                    self.hud.failureHidden("请输入正确的手机号")
                    return false
                }
                return true
        }.asDriver()
        ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] (phone) in
                STProvider.request(.sendCode(mobile: phone))
                    .map(model: ResponseModel.self)
                    .subscribe(onSuccess: { [weak self] (_) in
                        self?.hud.successHidden("验证码发送成功")
                        }, onError: { [weak self] (error) in
                            self?.hud.failureHidden(self?.errorMessage(error))
                    }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        
        let signal = Driver.combineLatest(phone, code){ ($0, $1) }
        next.withLatestFrom(signal)
            .filter { [unowned self] (phone, code) -> Bool in
                if code.count > 0 && phone.count > 0 {
                    return true
                }
                self.hud.failureHidden("请输入验证码")
                return false
        }.asDriver()
        ._doNext(forNotice: hud)
            .drive(onNext: { (phone, code) in
                self.bindPhoneRequest(mobile: phone, code: code, op_openid: op_openid)
            }).disposed(by: disposeBag)
    }
    
    func bindPhoneRequest(mobile: String, code: String, op_openid: String) {
        STProvider.request(.bindPhone(mobile: mobile, code: code, op_openid: op_openid))
            .map(model: LoginModel.self)
            .subscribe(onSuccess: { [weak self] (_) in
                self?.hud.successHidden("手机号绑定成功")
                }, onError: { [weak self] (error) in
                    self?.hud.failureHidden(self?.errorMessage(error))
            }).disposed(by: self.disposeBag)
    }
    
}
