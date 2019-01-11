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
    
    let datasource = Variable([SectionModel<SectionCourseClassModel ,CourseClassModel>]())
    
    init(tap: Driver<Void>) {
        super.init()
        
        delShopingSubject
            .subscribe(onNext: { [unowned self] model in self.dealDel(model: model) })
            .disposed(by: disposeBag)
        
        sectionSelectedSubject
            .subscribe(onNext: { [unowned self] model in self.dealSectionSelected(model: model) })
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
        var tempData = datasource.value
        for  i in 0..<tempData.count {
            var section = datasource.value[i]
            for j in 0..<section.items.count {
                if section.items[j].class_id == model.class_id {
                    tempData[i].items.remove(at: j)
                    CourseClassModel.remove(classInfo: model.class_id)
                    break
                }
            }
        }
        
        datasource.value = tempData
    }
    
    private func dealSectionSelected(model: SectionCourseClassModel) {
        var tempData = [SectionModel<SectionCourseClassModel ,CourseClassModel>]()
        for section in datasource.value {
            if section.model.shopId == model.shopId {
                for item in section.items {
                    item.isSelected = model.isSelected
                }
            }
            
            tempData.append(section)
        }
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
            ShoppingCartViewModel.sbPush("STHome", "verifyCtrlID", parameters: ["models": buyModel])
        }
    }
}
