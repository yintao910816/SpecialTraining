//
//  User.swift
//  SpecialTraining
//
//  Created by sw on 25/01/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import HandyJSON

class LoginModel: HJModel {

    var access_token: String = ""
    var expires_time: Int = 0
    var refresh_token: String = ""
    var refresh_expires_time: Int = 0
    
    var member: UserInfoModel!
}

class UserInfoModel: HJModel {
    var uid: Int = 0
    var mob: String = ""
    var code: String = ""
    var pwd: String = ""
    var nickname: String = ""
    var sex: String = ""
    var headimgurl: String = ""
    var parent_id: String = ""
    var op_openid: String = ""
    var mp_openid: String = ""
    var pid: String = ""
    var createtime: String = ""
    
    override func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &uid, name: "id")
    }
}
