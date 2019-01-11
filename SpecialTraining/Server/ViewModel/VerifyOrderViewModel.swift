//
//  VerifyOrderViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/1/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class VerifyOrderViewModel: BaseViewModel {
    
    let datasource = Variable([SectionModel<CourseClassModel, CourseClassModel>]())
    
    init(models: [CourseClassModel]) {
        super.init()
        
        var tempDatas = [SectionModel<CourseClassModel, CourseClassModel>]()
        
        var findShopids = [String: String]()
        for item in models { findShopids[item.shop_id] = "" }
        let allShopids = findShopids.keys
        
        for shopId in allShopids {
            let tempModels = models.filter{ $0.shop_id == shopId }
            if let model = tempModels.first {
                tempDatas.append(SectionModel.init(model: model, items: tempModels))
            }
        }
//        tempDatas.last?.items.last?.isLasstRow = true
        datasource.value = tempDatas

    }
}
