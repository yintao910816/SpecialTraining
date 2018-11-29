//
//  AppConfig.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

public func RGB(_ r : CGFloat, _ g : CGFloat, _ b : CGFloat, _ a : CGFloat = 1) ->UIColor{
    return UIColor(red : r / 255.0 ,green : g / 255.0 ,blue : b / 255.0 ,alpha : a)
}

// 分割线颜色
let SEP_LINE_COLOR = RGB(246, 246, 246)

let ST_MAIN_COLOR = RGB(2, 183, 240)
// 渐变色
let ST_MAIN_COLOR_LIGHT = RGB(102, 214, 249)
let ST_MAIN_COLOR_DARK  = RGB(19, 164, 253)

let THEME_GRADIENT_COLORS = [ST_MAIN_COLOR_LIGHT.cgColor, ST_MAIN_COLOR_DARK.cgColor]
let THEME_GRADIENT_LOCATIONS = [NSNumber.init(value: 0.05), NSNumber.init(value: 1)]

// 深灰色 -> 文字
let GRAY_DARK_COLOR = RGB(138, 138, 138)
// 浅灰色 -> 线条
let GRAY_LIGHT_COLOR = RGB(236, 236, 236)

