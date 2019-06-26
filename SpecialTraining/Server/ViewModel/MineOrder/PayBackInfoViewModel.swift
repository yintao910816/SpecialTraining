//
//  PayBackInfoViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/4/24.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class PayBackInfoViewModel: BaseViewModel {
    
    let dataSource = Variable([SectionModel<RefundDetailsModel, OrderItemModel>]())
    let canclePayBack = PublishSubject<Void>()
    
    private var memberOrder: MemberAllOrderModel!
    
    init(memberOrder: MemberAllOrderModel) {
        super.init()
        
        self.memberOrder = memberOrder
        
        canclePayBack
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [weak self] _ in
                self?.requestCanclePayBack()
            })
            .disposed(by: disposeBag)
        
        reloadSubject
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [weak self] _ in
                self?.requestPayBackInfo()
            })
            .disposed(by: disposeBag)
    }
    
    private func requestCanclePayBack() {
        STProvider.request(.canclePayBack(order_no: memberOrder.order_number))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] res in
                if res.errno == 0 {
                    self?.hud.successHidden("取消成功", {
                        NotificationCenter.default.post(name: NotificationName.Order.canclePayBack, object: nil)
                        self?.popSubject.onNext(Void())
                    })
                }else {
                    self?.hud.failureHidden(res.errmsg)
                }
            }, onError: { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
    }
    
    private func requestPayBackInfo() {
        STProvider.request(.refundDetails(order_no: memberOrder.order_number))
            .map(model: RefundDetailsModel.self)
            .subscribe(onSuccess: { [weak self] model in
                guard let strongSelf = self else { return }
                strongSelf.dataSource.value = [SectionModel.init(model: model, items: strongSelf.memberOrder.orderItem)]
                self?.hud.noticeHidden()
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
}
