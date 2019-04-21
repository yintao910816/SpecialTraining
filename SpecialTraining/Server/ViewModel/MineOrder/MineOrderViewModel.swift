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
        
        reloadSubject
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [weak self] in
            self?.loadData()
        })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        STProvider.request(.getMemberAllOrder(member_id: "1"))
            .map(models: MemberAllOrderModel.self)
            .subscribe(onSuccess: { [weak self] model in
                PrintLog(model)
                self?.hud.noticeHidden()
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
        
        needPayDatasource.value = ["a", "b", "c", "d"]
        needCourseDatasource.value = ["a", "b", "c", "d"]
        needClassasource.value = ["a", "b", "c", "d"]
        needPayBackDatasource.value = ["a", "b", "c", "d"]
    }
    
}
