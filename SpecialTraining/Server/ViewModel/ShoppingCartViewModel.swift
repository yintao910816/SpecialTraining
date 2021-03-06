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
    
    let delShopingSubject = PublishSubject<CourseDetailClassModel>()
    let sectionSelectedSubject = PublishSubject<SectionCourseClassModel>()
    let cellSelectedSubject = PublishSubject<CourseDetailClassModel>()
    let allSelectedSubject = PublishSubject<Bool>()
    let changeCountSubject = PublishSubject<(Bool, CourseDetailClassModel)>()

    let totlePriceObser = Variable("0.0")
    let totleShopCountObser = Variable("购物车空空如也")
    
    private var shopCount: Int = 0
    
    let datasource = Variable([SectionModel<SectionCourseClassModel ,CourseDetailClassModel>]())
    
    public func hasSection(section: Int) ->Bool{
        if datasource.value.count > section {
            return datasource.value[section].items.count > 0
        }
        return false
    }
    
    init(tap: Driver<Void>) {
        super.init()
        
        delShopingSubject
            .subscribe(onNext: { [unowned self] model in self.dealDel(model: model) })
            .disposed(by: disposeBag)
        
        sectionSelectedSubject
            .subscribe(onNext: { [unowned self] model in self.dealSectionSelected(model: model) })
            .disposed(by: disposeBag)
        
        allSelectedSubject
            .subscribe(onNext: { [unowned self] isSelected in self.dealAllSelected(isSelected: isSelected) })
            .disposed(by: disposeBag)
        
        cellSelectedSubject
            .subscribe(onNext: { [unowned self] model in
                var tempPrice: Double = Double(self.totlePriceObser.value) ?? 0
                if model.isSelected == true {
                    tempPrice += Double(model.price) ?? 0
                }else {
                    tempPrice -= Double(model.price) ?? 0
                }
                self.totlePriceObser.value = "\(tempPrice)"
            })
            .disposed(by: disposeBag)
        
        changeCountSubject
            .subscribe(onNext: { [unowned self] p in self.dealChangeCount(isAdd: p.0, model: p.1) })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(NotificationName.Order.AddOrder)
            .subscribe(onNext: { [unowned self] no in
                self.dealAddOrder(model: no.object as? CourseDetailClassModel)
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
        
        CourseDetailClassModel.selectedAllOrderClass()
            .do(onNext: { [unowned self] datas in
                self.shopCount = datas.count
                self.totleShopCountObser.value = datas.count == 0 ? "购物车空空如也" : "共\(datas.count)件商品"
            })
            .map { datas -> [SectionModel<SectionCourseClassModel ,CourseDetailClassModel>] in
                var findShopids = [String: String]()
                for item in datas {
                    findShopids[item.shop_id] = ""
                }
                let allShopids = findShopids.keys
                
                var tempData = [SectionModel<SectionCourseClassModel ,CourseDetailClassModel>]()
                for shopId in allShopids {
                    let models = datas.filter{ $0.shop_id == shopId }
                    models.last?.isLasstRow = true
                    let sectionModel = SectionCourseClassModel.init(shopId: shopId, shopName: models.first?.shop_name)
                    tempData.append(SectionModel.init(model: sectionModel, items: models))
                }

                return tempData
            }
            .bind(to: datasource)
            .disposed(by: disposeBag)
    }
    
    private func dealDel(model: CourseDetailClassModel) {
        shopCount -= 1
        totleShopCountObser.value = shopCount <= 0 ? "购物车空空如也" : "共\(shopCount)件商品"

        var tempData = datasource.value
        for  i in 0..<tempData.count {
            var section = datasource.value[i]
            for j in 0..<section.items.count {
                if section.items[j].class_id == model.class_id {
                    tempData[i].items.remove(at: j)
                    if tempData[i].items.count > 0 {
                        tempData[i].items.last?.isLasstRow = true
                    }else {
                        tempData.remove(at: i)
                    }
                    
                    if section.items[j].isSelected == true {
                        totlePriceObser.value = "\((Double(totlePriceObser.value) ?? 0) - (Double(section.items[j].price) ?? 0))"
                    }
                    CourseDetailClassModel.remove(classInfo: model.class_id)
                    break
                }
            }
        }
        
        datasource.value = tempData
    }
    
    private func dealChangeCount(isAdd: Bool, model: CourseDetailClassModel) {
        
        let tempPrice: Double = Double(totlePriceObser.value) ?? 0
        if isAdd == true {
            totlePriceObser.value = "\(tempPrice + model.calculatePrice)"
        }else {
            totlePriceObser.value = "\(tempPrice - model.calculatePrice)"
        }
    }
    
    private func dealAddOrder(model: CourseDetailClassModel?) {
        guard let courseClassModel = model else {
            return
        }
        
        courseClassModel.isSelected = false

        var isExistSection: Bool = false
        var tempData = datasource.value
        for i in 0..<tempData.count {
            var section = tempData[i]
            if section.model.shopId == courseClassModel.shop_id {
                isExistSection = true

                if section.items.contains(where: { $0.class_id == model?.class_id }) == false {
                    section.items.insert(courseClassModel, at: 0)
                    section.items.last?.isLasstRow = true
                    tempData[i] = section
                }
                break
            }
        }

        if isExistSection == true {
            datasource.value = tempData
        }else {
            courseClassModel.isLasstRow = true
            let sectionModel = SectionCourseClassModel.init(shopId: courseClassModel.shop_id, shopName: courseClassModel.shop_name)
            let section = SectionModel.init(model: sectionModel, items: [courseClassModel])
            tempData.insert(section, at: 0)
            datasource.value = tempData
        }
        
        shopCount += 1
        totleShopCountObser.value = shopCount <= 0 ? "购物车空空如也" : "共\(shopCount)件商品"
    }
    
    private func dealAllSelected(isSelected: Bool) {
        print("全选状态：\(isSelected)")
        var tempData = datasource.value
        var tempPrice: Double = 0
        // UI界面更新
        tempData = tempData.compactMap({ data -> SectionModel<SectionCourseClassModel, CourseDetailClassModel> in
            var tempSection = data
            tempSection.model.isSelected = isSelected
            
            var tempModel = tempSection.items
            tempModel = tempModel.compactMap({ model -> CourseDetailClassModel in
                let aModel = model
                aModel.isSelected = isSelected
                if isSelected == true { tempPrice += Double(aModel.price) ?? 0 }
                return aModel
            })
            
            tempSection.items = tempModel
            
            return tempSection
        })
        
        // 总价显示更新
        totlePriceObser.value = String.init(format: "%.2f", tempPrice)
        
        datasource.value = tempData
    }
    
    private func dealSectionSelected(model: SectionCourseClassModel) {
        var tempData = [SectionModel<SectionCourseClassModel ,CourseDetailClassModel>]()
        // UI界面更新
        for section in datasource.value {
            if section.model.shopId == model.shopId {
                for item in section.items {
                    item.isSelected = model.isSelected
                }
            }
            
            tempData.append(section)
        }
        
        // 总价显示更新
        var doublePrice: Double = 0
        for section in tempData {
            for item in section.items {
                if item.isSelected == true {
                    doublePrice += Double(item.price) ?? 0
                }
            }
        }
        
        totlePriceObser.value = "\(doublePrice)"
        datasource.value = tempData
    }
    
    private func prepareBuyModel() {
        var classIds = [String]()
        for section in datasource.value {
            for item in section.items {
                if item.isSelected == true {
                    classIds.append(item.class_id)
                }
            }
        }
        
        if classIds.count == 0 {
            hud.failureHidden("请选择要购买的课程")
        }else {
            ShoppingCartViewModel.sbPush("STHome", "verifyCtrlID", parameters: ["classIds": classIds], title: "确认订单")
        }
    }
}
