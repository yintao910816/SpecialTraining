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

class SingleResponseModel: ResponseModel {
    var data: String = ""
}

class DataModel<T>: ResponseModel {
    
    var data: T?

}

class PhotoModel: CarouselSource {
    
    var photoURL: String = ""
    
    class func creatPhotoModels(photoList: [String]) ->[PhotoModel] {
        var datas = [PhotoModel]()
        for item in photoList {
            let model = PhotoModel()
            model.photoURL = item
            datas.append(model)
        }
        return datas
    }
    
    var url: String? { return photoURL }
}

