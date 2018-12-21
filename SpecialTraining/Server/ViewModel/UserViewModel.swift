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
    
    var loginType: String!
    
    var security = Variable(true)
    
    init(input:(account: Driver<String>, passwd: Driver<String>),
         tap: (loginTap: Driver<Void>, sendCodeTap: Driver<Void>, wechatTap: Driver<Void>), loginType: String) {
        super.init()
        self.loginType = loginType
        
        //微信授权登录
        tap.wechatTap.drive(onNext: {
            if WXApi.isWXAppInstalled() {
                let req = SendAuthReq.init()
                req.scope = "snsapi_userinfo"
                req.state = "com12312312"
                WXApi.send(req)
            } else {
                self.hud.failureHidden("请先安装微信")
            }
        }).disposed(by: disposeBag)
        
        //微信授权回调通知
        NotificationCenter.default.rx.notification(NotificationName.WX.WXAuthLogin)
            .subscribe(onNext: { [unowned self] (notification) in
                let code: String = notification.userInfo!["str"] as! String
                self.wxLogin(code: code)
            }).disposed(by: disposeBag)
        
        if self.loginType == "1" {//change security
            tap.sendCodeTap.drive(onNext: { [unowned self] (_) in
                self.security.value = !self.security.value
            }).disposed(by: disposeBag)
        } else if self.loginType == "2" {//验证码发送
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
        }
        
        //登录
        let signal = Driver.combineLatest(input.account, input.passwd) { ($0, $1) }
        tap.loginTap.withLatestFrom(signal)
            .filter { [unowned self] (account, pass) -> Bool in
                if account.count > 0 && pass.count > 0 {
                    return true
                }
                self.hud.failureHidden("请填写用户名密码")
                return false
            }
            .asDriver()
            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] (account, pass) in
                if self.loginType == "1" {
                    self.loginRequest(account: account, code: "", password: pass)
                } else if self.loginType == "2" {
                    self.loginRequest(account: account, code: pass, password: "")
                }
            })
            .disposed(by: disposeBag)
    }
    //登录
    func loginRequest(account: String,code: String, password: String) {
        STProvider.request(.login(mobile: account, code: code, pswd: password))
            .map(model: LoginModel.self)
            .subscribe(onSuccess: { [weak self] model in
//                STHelper.share.saveLoginUser(user: userInfo)
//
//                STHelper.imLogin(uid: userInfo.uid, pass: userInfo.pwd)
                
                self?.hud.successHidden("登录成功", {
                    self?.popSubject.onNext(true)
                })
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
    //微信登录
    func wxLogin(code: String) {
        STProvider.request(.thirdPartyLogin(code: code))
            .map(model: WXLoginModel.self)
            .subscribe(onSuccess: { [weak self] (loginModel) in
                if loginModel.is_bind_mobile == 0 {
                    LoginViewModel.sbPush("STLogin", "bindPhone",bundle: Bundle.main, parameters: ["op_openid":loginModel.op_openid])
                } else {
                    self?.hud.successHidden("登录成功", {
                        self?.popSubject.onNext(true)
                    })
                }
                
                }, onError: { [weak self] (error) in
                    self?.hud.failureHidden(self?.errorMessage(error))
            }).disposed(by: disposeBag)
    }
    
    //发送验证码
    func sendAuthCode(phone: String) {
        STProvider.request(.sendCode(mobile: phone))
            .map(model: ResponseModel.self)
            .subscribe(onSuccess: { [weak self] (_) in
                self?.hud.successHidden("验证码发送成功")
                }, onError: { [weak self] (error) in
                    self?.hud.failureHidden(error.localizedDescription)
                    self?.sendCodeSubject.onNext(false)
            }).disposed(by: disposeBag)
    }
}
