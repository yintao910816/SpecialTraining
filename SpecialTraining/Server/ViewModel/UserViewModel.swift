//
//  UserViewModel.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/20.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: BaseViewModel,VMNavigation {
    
    var sendCodeSubject = PublishSubject<Bool>()
    var bindPhoneSubject = PublishSubject<String>()
    
    var security = Variable(true)
    
    init(input:(account: Driver<String>, code: Driver<String>),
         tap: (loginTap: Driver<Void>, sendCodeTap: Driver<Void>, wechatTap: Driver<Void>)) {
        super.init()
        
        //微信授权登录
        tap.wechatTap.asObservable()
            ._doNext(forNotice: hud)
            .subscribe(onNext: { _ in
                let req = SendAuthReq.init()
                req.state = "wx_oauth_authorization_state"
                req.scope = "snsapi_userinfo"
                
                WXApi.send(req)
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(NotificationName.WX.WXAuthLogin)
            .subscribe(onNext: { [weak self] no in
                if let code = no.object as? String {
                    self?.wxLogin(code: code)
                }
            })
            .disposed(by: disposeBag)
        
        tap.sendCodeTap.withLatestFrom(input.account)
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

        //登录
        let signal = Driver.combineLatest(input.account, input.code) { ($0, $1) }
        tap.loginTap.withLatestFrom(signal)
            .filter { [unowned self] (account, pass) -> Bool in
                if account.count > 0 && pass.count > 0 {
                    return true
                }
                self.hud.failureHidden("请填写用户名和验证码")
                return false
            }
            .asDriver()
            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] (account, code) in
                self.loginRequest(account: account, code: code)
            })
            .disposed(by: disposeBag)
    }
    //登录
    func loginRequest(account: String,code: String) {
        STProvider.request(.login(mobile: account, code: code))
            .map(model: LoginModel.self)
            .subscribe(onSuccess: { [weak self] model in
//                STHelper.share.saveLoginUser(user: userInfo)
//
//                STHelper.imLogin(uid: userInfo.uid, pass: userInfo.pwd)
                userDefault.token = model.access_token
                userDefault.uid = model.member.uid
                self?.hud.successHidden("登录成功", {
                    self?.popSubject.onNext(Void())
                })
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
    private func wxLogin(code: String) {
        STProvider.request(.wxLogin(code: code))
            .map(model: LoginModel.self)
            .subscribe(onSuccess: { [weak self] model in
                userDefault.token = model.access_token
                if model.member.is_bind_mobile == true {
                    self?.hud.successHidden("登录成功", {
                        self?.popSubject.onNext(Void())
                    })
                }else {
                    self?.hud.noticeHidden()
                    self?.bindPhoneSubject.onNext(model.member.op_openid)
                }
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
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
