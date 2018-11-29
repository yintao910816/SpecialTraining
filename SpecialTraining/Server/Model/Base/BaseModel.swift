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
 
    var message: String = ""
    var success: Bool = true
    var code: Int = 200
        
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            [message       <-- "Message",
             success       <-- "Success"]
    }
    
}

class DataModel<T>: ResponseModel {
    var total: NSInteger? = 0
    var data: T?
    
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)

        mapper.specify(property: &total, name: "Total")
    }

}

