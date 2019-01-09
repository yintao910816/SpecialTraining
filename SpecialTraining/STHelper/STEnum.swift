//
//  STEnum.swift
//  SpecialTraining
//
//  Created by yintao on 2019/1/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation

enum ClassLevel: String {
    // 初级
    case primary = "C"
    // 中级
    case middle  = "B"
    // 高级
    case senior  = "A"
}

extension ClassLevel {
    var levelText: String {
        switch self {
        case .primary:
            return "初级"
        case .middle:
            return "中级"
        case .senior:
            return "高级"
        }
    }
}
