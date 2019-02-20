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
        _ = STProvider.request(.login(mobile: account, code: password))
            .map(model: UserInfoModel.self)
            .subscribe(onSuccess: { userInfo in
                STHelper.share.saveLoginUser(user: userInfo)                
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

import AVFoundation
extension STHeader {
    
    static func getVideoDuration(path: URL) ->Int {
        let asset = AVURLAsset.init(url: path)
        let time = asset.duration
        let sections = round(Float(time.value)/Float(time.timescale))
        return Int(sections)
    }
}
