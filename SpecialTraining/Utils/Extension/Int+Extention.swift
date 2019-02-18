//
//  Int+Extention.swift
//  SpecialTraining
//
//  Created by yintao on 2019/2/19.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation

extension Int {
    /// 小与10自动补0
    var fixInt: String {
        return self < 10 ? "0\(self)" : "\(self)"
    }
}
