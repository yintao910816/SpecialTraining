//
//  Date+Extension.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/24.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation

extension Date {
    
    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }    
}
