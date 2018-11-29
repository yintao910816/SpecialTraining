//
//  PageModel.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/12/9.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import UIKit

class PageModel: NSObject {

    // 当前页数
    lazy var currentPage  = 1
    // 总共分页数
    lazy var totlePage    = 1
    // 每页多少条数据
    lazy var pageSize     = 20
    // 总共数据条数
    lazy var totle        = 1
    
    public var hasNext: Bool {
        get {
            totlePage = (totle / pageSize) + (totle % pageSize == 0 ? 0 : 1)
            return currentPage < totlePage
        }
    }
    
    /**
     发起请求钱调用
     */
    public func setupCurrentPage(refresh: Bool = true) {
        currentPage = refresh ? 1 : currentPage + 1
    }
}
