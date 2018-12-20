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
    
    init(input:(account: Driver<String>, passwd: Driver<String>),
         tap: Driver<Void>, loginType: String) {
        super.init()
        self.loginType = loginType
        //微信授权登录
        NotificationCenter.default.rx.notification(NotificationName.WX.WXLoginSuccess)
            .subscribe(onNext: { [unowned self] (notification) in
                let code = notification.object as! String
                STProvider.request(.thirdPartyLogin(code:code))
                    .map(model: WXLoginModel.self)
                    .subscribe(onSuccess: { [weak self] (model) in
                        LoginViewModel.sbPush("STLogin", "bindPhone",bundle: Bundle.main, parameters: ["op_openid":model.op_openid])
                        }, onError: { [weak self] (error) in
                            self?.hud.failureHidden(self?.errorMessage(error))
                    }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        //验证码发送
        sendCodeSubject.withLatestFrom(input.account)
            .filter { [unowned self] (phone) -> Bool in
                if ValidateNum.phoneNum(phone).isRight == false {
                    self.hud.failureHidden("请输入正确的手机号")
                    return false
                }
                return true
        }._doNext(forNotice: hud)
            .subscribe(onNext: { (phone) in
                STProvider.request(.sendCode(mobile: phone))
                    .map(model: ResponseModel.self)
                    .subscribe(onSuccess: { [weak self] (_) in
                        self?.hud.successHidden("验证码发送成功")
                        }, onError: { [weak self] (error) in
                            self?.hud.failureHidden(self?.errorMessage(error))
                    }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        //登录
        let signal = Driver.combineLatest(input.account, input.passwd) { ($0, $1) }
        tap.withLatestFrom(signal)
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
}

class RegisterViewModel: BaseViewModel {
    
    init(input:(account: Driver<String>, passwd: Driver<String>, nickName: Driver<String>),
         tap: Driver<Void>) {
        super.init()
        
        let signal = Driver.combineLatest(input.account, input.passwd, input.nickName) { ($0, $1, $2) }
        tap.withLatestFrom(signal)
            .filter { [unowned self] (account, pass, nickName) -> Bool in
                if account.count > 0 && pass.count > 0 && nickName.count > 0 {
                    return true
                }
                self.hud.failureHidden("请输入完整信息")
                return false
            }
            .asDriver()
            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] (account, pass, nickName) in
                self.register(account: account, password: pass, nickName: nickName)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func register(account: String, password: String, nickName: String) {
        STProvider.request(.register(username: account, password: password, nickname: nickName))
            .map(model: UserInfoModel.self)
            .subscribe(onSuccess: { [weak self] userInfo in
                STHelper.share.saveLoginUser(user: userInfo)
                
                STHelper.imLogin(uid: userInfo.uid, pass: userInfo.pwd)
                
                self?.hud.successHidden("注册成功", {
                    self?.popSubject.onNext(true)
                })
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
}
