//
//  HasPayViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/6/27.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class HasPayViewModel: BaseViewModel {
    
    private var memberOrder: MemberAllOrderModel!
    
    let dataSource = Variable([SectionModel<MemberAllOrderModel, OrderItemModel>]())
    public let payBackSubject = PublishSubject<Void>()

    init(memberOrder: MemberAllOrderModel) {
        super.init()
        self.memberOrder = memberOrder
        
        reloadSubject
            .subscribe(onNext: { [weak self] in
                self?.dataSource.value = [SectionModel.init(model: memberOrder, items: memberOrder.orderItem)]
            })
            .disposed(by: disposeBag)
        
        payBackSubject
            .subscribe(onNext: { [unowned self] in
                NoticesCenter.alert(title: "取消订单",
                                    message: "请确认是否要取消订单",
                                    cancleTitle: "取消",
                                    okTitle: "确定")
                {
                    self.requestPayBack(orderNo: self.memberOrder.order_number)
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// 退款
    private func requestPayBack(orderNo: String) {
        hud.noticeLoading()
        STProvider.request(.refundOrder(order_no: orderNo))
            .mapResponse()
            .asObservable()
            .subscribe(onNext: { [weak self] data in
                self?.hud.successHidden("退款成功", {
                    self?.popSubject.onNext(Void())
                })
                }, onError: { [weak self] error in
                    self?.hud.failureHidden(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
    }
}
