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
    
    static let shre = UserAccountServer()
    
    // 当前登录用户信息
    var loginUser = LoginModel()
 
    final func save(loginUser userModel: LoginModel) {
        loginUser = userModel
        
        userDefault.token = userModel.access_token
        userDefault.uid = userModel.member.uid

        UserInfoModel.inster(user: userModel)
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
