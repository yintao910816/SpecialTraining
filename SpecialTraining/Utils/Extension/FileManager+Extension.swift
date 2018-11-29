//
//  FileManager+Extension.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/3/24.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation

extension FileManager {

    /// Bundle.main.resourcePath 路劲下是否存在文件
    ///
    /// - Parameters:
    ///   - fileName: 文件名
    ///   - type: 文件类型
    /// - Returns: true / false
    public func dirExists(forFileName fileName: String, forType type: String) ->Bool {
        let fullPath = resourcePath() + fileName + ".\(type)"
        return fileExists(atPath: fullPath)
    }
    
    private func resourcePath() ->String {
        return (Bundle.main.resourcePath! + "/")
    }
    
}
