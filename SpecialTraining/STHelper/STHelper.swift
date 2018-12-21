//
//  STHelper.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/17.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxSwift

class STHelper {
    
    static let share = STHelper()
    
    var loginUser: UserInfoModel?
    
    /**
     * 用户信息保存
     */
    func saveLoginUser(user: UserInfoModel) {
        loginUser = user
        userDefault.uid = user.uid
    }
    
    /**
     * 按用户ID查询用户信息
     */
    func findUser(uid: String) ->Observable<UserInfoModel> {
        return Observable<UserInfoModel>.create { [unowned self] obser -> Disposable in
            _ = self.findUser(uid: uid)
                .subscribe(onSuccess: { userInfo in
                    obser.onNext(userInfo)
                    obser.onCompleted()
                }, onError: { error in
                    obser.onError(error)
                    obser.onCompleted()
                })
            return Disposables.create { }
        }
    }
    
    func findUser(uid: String) ->Single<UserInfoModel> {
        return STProvider.request(.getUserInfo(uid: uid))
            .map(model: UserInfoModel.self)
    }
    
    // 弹出登录界面
    class func presentLogin() {
        let sb = UIStoryboard.init(name: "STLogin", bundle: Bundle.main)
        let loginCtr = sb.instantiateViewController(withIdentifier: "loginNavID") as! MainNavigationController
        NSObject().visibleViewController?.present(loginCtr, animated: true, completion: nil)
    }
}

extension STHelper {
    
    // 登录环信IM
    class func imLogin(uid: String, pass: String) {
        if let error = EMClient.shared()?.login(withUsername: uid, password: pass) {
            PrintLog("环信账号登录失败：\(error.errorDescription)")
        }else {
            PrintLog("环信账号登录成功")
            NotificationCenter.default.post(name: NotificationName.EaseMob.ConversationListChange, object: nil)
            
            STAppDelegate.appDelegate.chatRoomManager.emRegisterDelegate()
            // 注册好友回调
        }
    }
    
    // 平台用户登录
    class func login(account: String, password: String) {
        _ = STProvider.request(.login(mobile: account, code: "", pswd: password))
            .map(model: UserInfoModel.self)
            .subscribe(onSuccess: { userInfo in
                STHelper.share.saveLoginUser(user: userInfo)
                
                STHelper.imLogin(uid: userInfo.uid, pass: userInfo.pwd)
            }) {  error in
        }
    }
    
}

extension STHelper {
    
    class func themeColorLayer(frame: CGRect) ->CAGradientLayer {
        let gradientLayer = CAGradientLayer.gradient(colors: THEME_GRADIENT_COLORS, locations: THEME_GRADIENT_LOCATIONS)
        gradientLayer.frame = frame
        return gradientLayer
    }
}

extension STHelper {
    //发起微信登陆授权请求
    public class func authorizeWchat() ->Observable<SSDKUser> { return authorize(.typeWechat) }
    
    private class func authorize(_ platform: SSDKPlatformType) ->Observable<SSDKUser> {
        return Observable<SSDKUser>.create({ obser -> Disposable in
            ShareSDK.authorize(platform,
                               settings: nil,
                               onStateChanged: { (state, user, error) in
                                
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
