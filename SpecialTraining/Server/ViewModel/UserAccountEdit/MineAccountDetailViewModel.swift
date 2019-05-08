//
//  MineAccountDetailViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class MineAccountDetailViewModel: BaseViewModel {
    
    var countAwardsObser = Variable("+0")
    var currentStatusObser = Variable("")
    var statementObser = Variable("")
    var applyTimeObser = Variable("")
    var receiveTimeObser = Variable("")
    var orderNumObser = Variable("")

    init(item_id: String, level: String) {
        super.init()
        
        reloadSubject
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [weak self] _ in
                self?.requestData(item_id: item_id, level: level)
            })
            .disposed(by: disposeBag)
    }
    
    private func requestData(item_id: String, level: String) {
        STProvider.request(.commissonDetails(item_id: item_id, level: level))
            .map(model: MineAwardDetailModel.self)
            .subscribe(onSuccess: { [weak self] model in
                self?.countAwardsObser.value = model.commission
                self?.currentStatusObser.value = model.statuText
                self?.statementObser.value = "推荐朋友购买g课程返现奖励"
                self?.applyTimeObser.value = model.applytime
                self?.receiveTimeObser.value = ""
                self?.orderNumObser.value = model.order_number
                
                self?.hud.noticeHidden()
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
}
