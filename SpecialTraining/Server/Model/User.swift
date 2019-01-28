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
    
    var member: UserInfoModel!
}

class UserInfoModel: HJModel {
    var code: String = ""
    var createtime: String = ""
    var headimgurl: String = ""
    var uid: Int = 0
    var is_bind_mobile: Bool = false
    var mob: String = ""
    var mp_openid: String = ""
    var nickname: String = ""
    var op_openid: String = ""
    var parent_id: String = ""
    var pid: String = ""
    var pwd: String = ""
    var sex: String = ""
    
    override func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &uid, name: "id")
    }
}
