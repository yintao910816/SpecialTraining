//
//  UserDefault.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/11/23.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation

let userDefault = UserDefaults.standard

extension UserDefaults{

    var uid: Int32 {
        get{
            guard let rtUID = (object(forKey: kUID) as? Int32) else {
                return 0
            }
            return rtUID
        }
        set{
            set(newValue, forKey: kUID)
            synchronize()
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
            return lat == 0 ? 30.356023 : lat
        }
        set{
            set(newValue, forKey: kUserLat)
            synchronize()
        }
    }
    
    var lng: CLLocationDegrees {
        get{
            let lng = double(forKey: kUserLng)
            return lng == 0 ? 112.21791 : lng
        }
        set{
            set(newValue, forKey: kUserLng)
            synchronize()
        }
    }
    
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
    
}
