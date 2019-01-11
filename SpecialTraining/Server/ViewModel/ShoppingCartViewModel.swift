//
//  ShoppingCartViewModel.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/17.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class ShoppingCartViewModel: BaseViewModel, VMNavigation {
    
    let delShopingSubject = PublishSubject<CourseClassModel>()
    let sectionSelectedSubject = PublishSubject<SectionCourseClassModel>()
    let cellSelectedSubject = PublishSubject<CourseClassModel>()

    let totlePriceObser = Variable("0")
    let totleShopCountObser = Variable("购物车空空如也")
    
    private var shopCount: Int = 0
    
    let datasource = Variable([SectionModel<SectionCourseClassModel ,CourseClassModel>]())
    
    init(tap: Driver<Void>) {
        super.init()
        
        delShopingSubject
            .subscribe(onNext: { [unowned self] model in self.dealDel(model: model) })
            .disposed(by: disposeBag)
        
        sectionSelectedSubject
            .subscribe(onNext: { [unowned self] model in self.dealSectionSelected(model: model) })
            .disposed(by: disposeBag)
        
        cellSelectedSubject
            .subscribe(onNext: { [unowned self] model in
                var tempPrice: Double = 0
                if model.isSelected == true {
                    tempPrice += Double(model.price) ?? 0
                }else {
                    tempPrice -= Double(model.price) ?? 0
                }
                self.totlePriceObser.value = "\(tempPrice)"
            })
            .disposed(by: disposeBag)

        tap.drive(onNext: { [unowned self] _ in self.prepareBuyModel() })
            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [unowned self] _ in
                self.prepareData()
            })
            .disposed(by: disposeBag)
    }
    
    private func prepareData() {
        
        CourseClassModel.slectedClassInfo()
            .do(onNext: { [unowned self] datas in
                self.shopCount = datas.count
                self.totleShopCountObser.value = datas.count == 0 ? "购物车空空如也" : "共\(datas.count)件商品"
            })
            .map { datas -> [SectionModel<SectionCourseClassModel ,CourseClassModel>] in
                var findShopids = [String: String]()
                for item in datas {
                    findShopids[item.shop_id] = ""
                }
                let allShopids = findShopids.keys
                
                var tempData = [SectionModel<SectionCourseClassModel ,CourseClassModel>]()
                for shopId in allShopids {
                    let models = datas.filter{ $0.shop_id == shopId }
                    
                    let sectionModel = SectionCourseClassModel.init(shopId: shopId, shopName: models.first?.shop_name)
                    tempData.append(SectionModel.init(model: sectionModel, items: models))
                }
                tempData.last?.items.last?.isLasstRow = true
                return tempData
            }
            .bind(to: datasource)
            .disposed(by: disposeBag)
    }
    
    private func dealDel(model: CourseClassModel) {
        shopCount -= 1
        totleShopCountObser.value = shopCount <= 0 ? "购物车空空如也" : "共\(shopCount)件商品"

        var tempData = datasource.value
        for  i in 0..<tempData.count {
            var section = datasource.value[i]
            for j in 0..<section.items.count {
                if section.items[j].class_id == model.class_id {
                    tempData[i].items.remove(at: j)
                    if section.items[j].isSelected == true {
                        totlePriceObser.value = "\((Double(totlePriceObser.value) ?? 0) - (Double(section.items[j].price) ?? 0))"
                    }
                    CourseClassModel.remove(classInfo: model.class_id)
                    break
                }
            }
        }
        
        datasource.value = tempData
    }
    
    private func dealSectionSelected(model: SectionCourseClassModel) {
        var doublePrice: Double = 0
        var tempData = [SectionModel<SectionCourseClassModel ,CourseClassModel>]()
        for section in datasource.value {
            if section.model.shopId == model.shopId {
                for item in section.items {
                    item.isSelected = model.isSelected
                    doublePrice += (Double(item.price) ?? 0)
                }
            }
            
            tempData.append(section)
        }
        
        totlePriceObser.value = "\(doublePrice)"
        
        datasource.value = tempData
    }
    
    private func prepareBuyModel() {
        var buyModel = [CourseClassModel]()
        for section in datasource.value {
            for item in section.items {
                if item.isSelected == true {
                    buyModel.append(item)
                }
            }
        }
        
        if buyModel.count == 0 {
            hud.failureHidden("请选择要购买的课程")
        }else {
            ShoppingCartViewModel.sbPush("STHome", "verifyCtrlID", parameters: ["models": buyModel], title: "确认订单")
        }
    }
}
