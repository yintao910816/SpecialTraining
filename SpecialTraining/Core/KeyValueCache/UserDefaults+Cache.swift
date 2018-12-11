//
//  UserDefault.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/11/23.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation

let userDefault = UserDefaults.standard
let noUID = "-UID520"

extension UserDefaults{

    var uid: String {
        get{
            // 升级swift版本之前的UID系统默认存为NSNumber，这里如果直接解包成String不会有值
            if let stUID = (object(forKey: kUID) as? String) {
                return stUID
            }
            return noUID
        }
        set{
            set(newValue, forKey: kUID)
            synchronize()
            AppSetup.instance.resetParam()
        }
    }
    var token: String {
        get{
            guard let rtToken = (object(forKey: kToken) as? String) else {
                return ""
            }
            return rtToken
        }
        set{
            if newValue.isEmpty == false {
                set(newValue, forKey: kToken)
                synchronize()
                AppSetup.instance.resetParam()
            }
        }
    }

    var lat: CLLocationDegrees {
        get{
            let lat = double(forKey: kUserLat)
            return lat == 0 ? 112.21791 : lat
        }
        set{
            set(newValue, forKey: kUserLat)
            synchronize()
        }
    }
    
    var lng: CLLocationDegrees {
        get{
            let lng = double(forKey: kUserLng)
            return lng == 0 ? 30.356023 : lng
        }
        set{
            set(newValue, forKey: kUserLng)
            synchronize()
        }
    }
    
//    var userState: String {
//        get {
//            guard let rtSserState = (object(forKey: kUserDefaultState) as? String) else {
//                return ""
//            }
//            return rtSserState
//        }
//        set {
//            set(newValue, forKey: kUserDefaultState)
//            synchronize()
//        }
//    }
    
    var lanuchStatue: String {
        get {
            guard let statue = (object(forKey: kLoadLaunchKey) as? String) else {
                return ""
            }
            return statue
        }
        set {
            set(newValue, forKey: kLoadLaunchKey)
            synchronize()
        }
    }
    
    // 本地数据库是否存在当前用户信息
//    var localUserInfo: UserInfoModel? {
//        get {
//            guard let decodedObject = (object(forKey: kLocalUserInfoModelKey) as? Data) else {
//                return nil
//            }
//            guard let object = (NSKeyedUnarchiver.unarchiveObject(with: decodedObject) as? UserInfoModel) else {
//                return nil
//            }
//            return object
//        }
//        set {
//            guard let obj = newValue else {
//                return
//            }
//            let encodedObject = NSKeyedArchiver.archivedData(withRootObject: obj)
//            set(encodedObject, forKey: kLocalUserInfoModelKey)
//            synchronize()
//        }
//    }
    
    // MARK: 保存用户id和用户类型
//    public func save(_ userType: UserType, _ uid: String, _ token: String) {
//    
//        self.uid      = uid
//        self.userType = userType
//        self.token    = token
//    }
}
