//
//  BaseFilesOwner.swift
//  ComicsReader
//
//  Created by 尹涛 on 2018/5/17.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

class BaseFilesOwner: NSObject {

    deinit {
        PrintLog("释放了 \(self)")
    }
}
