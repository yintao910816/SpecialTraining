//
//  UserAccountServer.swift
//  ComicsReader
//
//  Created by 尹涛 on 2018/8/20.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation
import RxSwift

class UserAccountServer {
    
    private let disposeBag = DisposeBag()
    
    static let share = UserAccountServer()
    
    // 当前登录用户信息
    var loginUser = LoginModel()
 
    final func save(loginUser userModel: LoginModel, isInsertDB: Bool = true) {
//        if userModel.member.uid <= 0 { return }
        
        loginUser = userModel
        
        userDefault.token = userModel.access_token
        userDefault.uid = userModel.member.uid

        if isInsertDB == true {
            // 环信
            STHelper.imLogin(uid: userModel.member.mob, pass: "123456")

            UserInfoModel.inster(user: userModel)
            NotificationCenter.default.post(name: NotificationName.user.loginSuccess, object: nil)
        }
    }
    
    final func loadLoginUser() {
        if userDefault.uid > 0 {
            UserInfoModel.slectedLoginUser()
                .subscribe(onNext: { UserAccountServer.share.loginUser = $0 })
                .disposed(by: disposeBag)
        }
    }
}

extension UserAccountServer { /**第三方登录授权相关*/
    
    public class func authorizeWchat() ->Observable<SSDKUser> { return authorize(.typeWechat) }
    
    private class func authorize(_ platform: SSDKPlatformType) ->Observable<SSDKUser> {
        return Observable<SSDKUser>.create({ obser -> Disposable in
            ShareSDK.authorize(platform,
                               settings: nil,
                               onStateChanged: { (state, user, error) in
                                PrintLog(state)
                                if state == .success {
                                    obser.onNext(user!)
                                    obser.onCompleted()
                                }else if state == .cancel {
                                    let _error = MapperError.server(message: "您取消了授权!")
                                    obser.onError(_error)
                                    obser.onCompleted()
                                }else {
                                    PrintLog(error?.localizedDescription)
                                    let _error = MapperError.server(message: error?.localizedDescription)
                                    obser.onError(_error)
                                    obser.onCompleted()
                                }
            })
            return Disposables.create()
        })
    }
    
}
