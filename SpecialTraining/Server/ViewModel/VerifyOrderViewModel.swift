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
    
    private var orderModels: [CourseClassModel]!
    
    init(models: [CourseClassModel]) {
        super.init()
        
        orderModels = models
        
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
        datasource.value = tempDatas

    }
    
    var totlePrice: NSAttributedString {
        get {
            var price: Double = 0
            for model in orderModels {
                price += (Double(model.price) ?? 0)
            }
            
            let priceText = "合计金额：￥\(price)"
            
            return priceText.attributed(NSRange.init(location: 5,
                                                     length: priceText.count - 5),
                                        RGB(236, 108, 54),
                                        nil)
        }
    }
}
