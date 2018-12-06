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

class MineOrderViewModel: RefreshVM<MineOrderModel> {
    
    let statusSource = Variable([MineOrderMenuModel]())
    
    let statusChangeSubject = PublishSubject<MineOrderMenuModel>()
    
    override init() {
        super.init()
        
        statusSource.value = [MineOrderMenuModel.createModel(title: "待付款", isSelected: true),
                              MineOrderMenuModel.createModel(title: "待排课/发货"),
                              MineOrderMenuModel.createModel(title: "待排课/收货"),
                              MineOrderMenuModel.createModel(title: "待评价")]
        
        self.datasource.value = [MineOrderModel(),MineOrderModel(),MineOrderModel(),MineOrderModel(),MineOrderModel()]
        
        statusChangeSubject.subscribe(onNext: { [unowned self] (model) in
            let tempDatas = self.statusSource.value
            self.statusSource.value = tempDatas.map({ d -> MineOrderMenuModel in
                d.isSelected = d.title == model.title ? true : false
                return d
            })
        }).disposed(by: disposeBag)
    }
    
}
