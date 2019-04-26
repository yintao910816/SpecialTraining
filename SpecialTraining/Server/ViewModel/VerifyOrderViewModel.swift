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
    
    let datasource = Variable([SectionModel<CourseDetailClassModel, CourseDetailClassModel>]())
    let totlePriceObser = Variable(NSAttributedString.init(string: "合计金额：¥0.00"))
    
    private var orderModels: [CourseDetailClassModel] = []
    private var classIds: [String] = []
    
    init(classIds: [String]) {
        super.init()
        
        self.classIds = classIds
        
        loadDbData()
    }
    
    private func loadDbData() {
        if classIds.count > 0 {
            CourseDetailClassModel.selectedOrderClass(classIds: classIds)
                .subscribe(onNext: { [weak self] datas in
                    self?.orderModels = datas
                    
                    if datas.count > 0 {
                        var tempDatas = [SectionModel<CourseDetailClassModel, CourseDetailClassModel>]()
                        
                        var findShopids = [String: String]()
                        for item in datas { findShopids[item.shop_id] = "" }
                        let allShopids = findShopids.keys
                        
                        for shopId in allShopids {
                            let tempModels = datas.filter{ $0.shop_id == shopId }
                            if let model = tempModels.first {
                                tempDatas.append(SectionModel.init(model: model, items: tempModels))
                            }
                        }
                        
                        self?.cacultePrice()
                        self?.datasource.value = tempDatas
                    }
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func cacultePrice() {
        var price: Double = 0
        for model in orderModels {
            price += (Double(model.price) ?? 0)
        }
        
        let priceText = "合计金额：￥\(price)"
        
        let retPrice = priceText.attributed(NSRange.init(location: 5,
                                                         length: priceText.count - 5),
                                            RGB(236, 108, 54),
                                            nil)
        
        totlePriceObser.value = retPrice
    }
}

enum OrderError: Swift.Error {
    case noOrder
}
