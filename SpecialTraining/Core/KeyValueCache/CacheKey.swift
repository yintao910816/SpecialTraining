//
//  CacheKey.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/11/23.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation

let kUID              = "uid"
let kToken            = "token"
let kNickName         = "nickname"
let kUserModel        = "usermodel"
let kAvatar           = "avatar"

/**
 * nsuserdefault 是否需要更新
 *
 * kUpdateUserDefault 存储是否需要更新值得key
 * kUpdateStateA      需要更新
 * kUpdateStateB      不需要更新
 */
let kUserDefaultState   = "updateUserDefault"
let vUpdateStateA       = "updateStateA"
let vUpdateStateB       = "updateStateB"

let kUserLat = "userLat"
let kUserLng = "userLng"

/**
 * 是否加载引导界面
 *
 * vLaunch 如果需要显示引导页，把该值+1
 */
let kLoadLaunchKey    = "loadLaunchKey"
let vLaunch   = "1"

