//
//  Bundle+Extension.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/4/27.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation

extension Bundle {
    
    /// 获取工程名字
    var projectName: String {
        get {
            return self.object(forInfoDictionaryKey: kCFBundleExecutableKey as String) as! String
        }
    }
    
    /// 构建版本号
    var buildVersion: String {
        get {
            return self.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
        }
    }
    
    /// app版本号
    var version: String {
        get {
            return self.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        }
    }
    
    /// app 名称
    var appName: String {
        get {
            return self.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
        }
    }
    
}

extension Bundle {
    
    func resource(fileName name: String,
                  ofType type: String = "png",
                  inDirectory dir: String = "Resources.bundle/",
                  subDirectory subDir: String = "images") ->String {
        return Bundle.main.path(forResource: name, ofType: type, inDirectory: dir + subDir) ?? ""
    }
}
