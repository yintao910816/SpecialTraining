//
//  HandyJSON+MapModel.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/12/5.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation
import HandyJSON

extension JSONDeserializer {

    public static func deserializeModelArrayFromArray(array: Array<NSDictionary>?) -> Array<T?>? {
        guard let _array = array else {
            return nil
        }
        var models = [T]()
        for dict in _array {
            models.append(self.deserializeFrom(dict: dict)!)
        }
        return models
    }
}
