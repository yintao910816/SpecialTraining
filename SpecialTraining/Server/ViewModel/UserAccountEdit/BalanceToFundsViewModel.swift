//
//  BalanceToFundsViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//  佣金提现

import Foundation
import RxCocoa

class BalanceToFundsViewModel: BaseViewModel {
    
    init(applyFunds: Driver<Void>) {
        super.init()
        
        applyFunds
            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] _ in
                self.requestApply()
            })
            .disposed(by: disposeBag)
    }
    
    private func requestApply() {
        STProvider.request(.commissionApply)
            .mapResponse()
            .subscribe(onSuccess: { [weak self] resModel in
                if resModel.errno == 0 {
                    self?.hud.successHidden("操作成功", { self?.popSubject.onNext(Void()) })
                }else {
                    self?.hud.failureHidden(resModel.errmsg)
                }
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
}
