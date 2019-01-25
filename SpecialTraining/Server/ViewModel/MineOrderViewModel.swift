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

class MineOrderViewModel: BaseViewModel {
    
    let needPayDatasource = Variable([String]())
    let needCourseDatasource = Variable([String]())
    let needClassasource = Variable([String]())
    let needPayBackDatasource = Variable([String]())

    override init() {
        super.init()
        
        reloadSubject.subscribe(onNext: { [weak self] in
            PrintLog("222222222222")
            self?.loadData()
        })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
//        STProvider.request(.getMemberAllOrder(member_id: "1"))
//        .map(model: MineOrderModel.self)
//            .subscribe(onSuccess: { model in
//               PrintLog(model)
//            }) { error in
//
//        }
        
        needPayDatasource.value = ["a", "b", "c", "d"]
        needCourseDatasource.value = ["a", "b", "c", "d"]
        needClassasource.value = ["a", "b", "c", "d"]
        needPayBackDatasource.value = ["a", "b", "c", "d"]
    }
    
}
