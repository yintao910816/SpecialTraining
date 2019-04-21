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
    
    private var openid: String = ""
    
    var sendCodeSubject = PublishSubject<Bool>()
    
    init(input: (phone: Driver<String>, code: Driver<String>, openid: String),
         tap: (sendAuth: Driver<Void>, next: Driver<Void>)) {
        super.init()
        self.openid = input.openid
        //发送验证码
        tap.sendAuth.withLatestFrom(input.phone)
            .filter { [unowned self] (phone) -> Bool in
                if ValidateNum.phoneNum(phone).isRight == false {
                    self.hud.failureHidden("请输入正确的手机号")
                    return false
                }
                return true
        }.asDriver()
        ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] (phone) in
                self.sendCodeSubject.onNext(true)
                self.sendAuthCode(phone: phone)
            }).disposed(by: disposeBag)
        //下一步
        let signal = Driver.combineLatest(input.phone, input.code){ ($0, $1) }
        tap.next.withLatestFrom(signal)
            .filter { [unowned self] (phone, code) -> Bool in
                if code.count > 0 && phone.count > 0 {
                    return true
                }
                self.hud.failureHidden("请输入验证码")
                return false
        }.asDriver()
        ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] (phone, code) in
                self.bindPhoneRequest(mobile: phone, code: code, op_openid: self.openid)
            }).disposed(by: disposeBag)
    }
    //绑定手机号
    func bindPhoneRequest(mobile: String, code: String, op_openid: String) {
        STProvider.request(.bindPhone(mobile: mobile, code: code, op_openid: op_openid))
            .map(model: LoginModel.self)
            .subscribe(onSuccess: { [weak self] (_) in
                self?.hud.successHidden("手机号绑定成功", {
                    self?.popSubject.onNext(Void())
                })
                }, onError: { [weak self] (error) in
                    self?.hud.failureHidden(self?.errorMessage(error))
            }).disposed(by: self.disposeBag)
    }
    
    //发送验证码
    func sendAuthCode(phone: String) {
        STProvider.request(.sendCode(mobile: phone))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] (_) in
                self?.hud.successHidden("验证码发送成功")
                }, onError: { [weak self] (error) in
                    PrintLog(error)
                    self?.hud.failureHidden(error.localizedDescription)
                    self?.sendCodeSubject.onNext(false)
            }).disposed(by: disposeBag)
    }
    
}
