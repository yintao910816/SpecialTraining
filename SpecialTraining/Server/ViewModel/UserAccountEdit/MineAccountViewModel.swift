//
//  MineAccountViewModel.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/3.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class MineAccountViewModel: BaseViewModel   {
    
    var totleAwardsObser = Variable("总奖金 ¥: 0")
    var canCommissionObser = Variable("可提现 ¥: 0")
    var listDatasource = Variable([MineAwardsModel]())
    
    private var mineAccountModel: MineAccountModel?
    
    override init() {
        super.init()
    
        reloadSubject
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [weak self] _ in
                self?.requestData()
            })
            .disposed(by: disposeBag)
    }
    
    private func requestData() {
        STProvider.request(.myCommission())
            .map(model: MineAccountModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.totleAwardsObser.value = "总奖金 ¥: \(data.total_commission)"
                self?.canCommissionObser.value = "可提现 ¥: \(data.can_commission)"
                self?.listDatasource.value = data.item_list
                self?.mineAccountModel = data
                
                self?.hud.noticeHidden()
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
    func getAccountModel() ->MineAccountModel? { return mineAccountModel }
}
