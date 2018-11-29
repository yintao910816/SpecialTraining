//
//  NSDictionary+Extension.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/6/20.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation

extension NSDictionary {

    /// 将字典转中的键值对转化到url中
    ///
    /// - Parameter params: 键值对
    /// - Returns: url 字符串
    public func keyValues() ->String {
        if allValues.count <= 0 {
            return ""
        }
        
        let string = NSMutableString.init(string: "?")
        enumerateKeysAndObjects({ (key, value, stop) in
            string.append("\(key)=\(value)&")
        })
        
        let range = string.range(of: "&", options: .backwards)
        string.deleteCharacters(in: range)
        return string as String
    }
    

    open override var debugDescription: String {
        get {
            do {
                let dicData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
                guard let r = String.init(data: dicData, encoding: .utf8) else {
                    return "打印失败"
                }
                return r
            } catch {
                return "打印失败"
            }
        }
    }

}
