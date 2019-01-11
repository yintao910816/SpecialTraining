//
//  ShoppingCartViewModel.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/17.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class ShoppingCartViewModel: BaseViewModel {
    
    let delShopingSubject = PublishSubject<CourseClassModel>()
    
    let datasource = Variable([SectionModel<String ,CourseClassModel>]())
    
    override init() {
        super.init()
        
        prepareData()
        
        delShopingSubject
            .subscribe(onNext: { [unowned self] model in self.dealDel(model: model) })
            .disposed(by: disposeBag)
    }
    
//    func cellHeight(indexPath: IndexPath) -> CGFloat {
//        let model = datasource.value[0].items[indexPath.row]
//        return model.height
//    }
    
    private func prepareData() {
        
        CourseClassModel.slectedClassInfo()
            .map { datas -> [SectionModel<String ,CourseClassModel>] in
                var findShopids = [String: String]()
                for item in datas { findShopids[item.shop_id] = "" }
                let allShopids = findShopids.keys
                
                var tempData = [SectionModel<String ,CourseClassModel>]()
                for shopId in allShopids {
                    let models = datas.filter{ $0.shop_id == shopId }
                    
                    tempData.append(SectionModel.init(model: shopId, items: models))
                }
                tempData.last?.items.last?.isLasstRow = true
                return tempData
            }
            .bind(to: datasource)
            .disposed(by: disposeBag)
    }
    
    private func dealDel(model: CourseClassModel) {
        var idx = 0
        var tempData = [SectionModel<String ,CourseClassModel>]()
        for  i in 0..<section.items.count {
            for j in 0..<section.items.count {
                if section.items[j].class_id == model.class_id {
                    
                    break
                }
            }
        }
    }
}
