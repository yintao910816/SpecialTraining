//
//  ServerDataModel.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/11/24.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation
import HandyJSON

// MARK:
// MARK: 所有请求数据
class ResponseModel: HJModel{
 
    var errno: Int = 0
    var errmsg: String = ""
    
}

class DataModel<T>: ResponseModel {
    
    var data: T?

}

