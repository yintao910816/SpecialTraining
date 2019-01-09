//
//  DB+Extension.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/7/17.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import SQLite

extension Connection {

    public var userVersion: Int32 {
        get { return Int32(try! scalar("PRAGMA user_version") as! Int64)}
        set { try! run("PRAGMA user_version = \(newValue)") }
    }
}
