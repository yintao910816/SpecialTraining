//
//  VideoPublish.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/31.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation

class VideoUploadAuthRefreshModel: HJModel {
    var RequestId: String = ""
    var UploadAddress: String = ""
    var UploadAuth: String = ""
    var VideoId: String = ""
}

class VideoSTSModel: HJModel {
    var RequestId: String = ""
    var AssumedRoleUser: String = ""
    var Credentials: String = ""
}

class AssumedRoleUserModel: HJModel {
    var AssumedRoleId: String = ""
    var Arn: String = ""
}

class CredentialsModel: HJModel {
    var AccessKeySecret: String = ""
    var AccessKeyId: String = ""
    var Expiration: String = ""
    var SecurityToken: String = ""
}

