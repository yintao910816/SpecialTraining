//
//  MineOrderViewModel.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/6.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MineOrderViewModel: BaseViewModel {
    
    let totleOrderDatasource   = Variable([SectionModel<MemberAllOrderModel, OrderItemModel>]())
    let needPayOrderDatasource = Variable([SectionModel<MemberAllOrderModel, OrderItemModel>]())
    let hasPayOrderDatasource  = Variable([SectionModel<MemberAllOrderModel, OrderItemModel>]())
    let payBackOrderDatasource = Variable([SectionModel<MemberAllOrderModel, OrderItemModel>]())

    override init() {
        super.init()
        
        reloadSubject
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [weak self] in
            self?.loadData()
        })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        STProvider.request(.getMemberAllOrder(member_id: "100"))
            .map(models: MemberAllOrderModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.dealData(orderModels: data)
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
    private func dealData(orderModels: [MemberAllOrderModel]) {
        var totleOrderSectionData   = [SectionModel<MemberAllOrderModel, OrderItemModel>]()
        var needPayOrderSectionData = [SectionModel<MemberAllOrderModel, OrderItemModel>]()
        var hasPayOrderSectionData  = [SectionModel<MemberAllOrderModel, OrderItemModel>]()
        var payBackOrderSectionData = [SectionModel<MemberAllOrderModel, OrderItemModel>]()

        for item in orderModels {
            let section = SectionModel<MemberAllOrderModel, OrderItemModel>.init(model: item, items: item.orderItem)
            totleOrderSectionData.append(section)
            switch item.statue {
            case .noPay:
                needPayOrderSectionData.append(section)
            case .haspay:
                hasPayOrderSectionData.append(section)
            case .packBack:
                payBackOrderSectionData.append(section)
            }
        }

        totleOrderDatasource.value = totleOrderSectionData
        needPayOrderDatasource.value = needPayOrderSectionData
        hasPayOrderDatasource.value  = hasPayOrderSectionData
        payBackOrderDatasource.value = payBackOrderSectionData
        
        hud.noticeHidden()
    }
}
