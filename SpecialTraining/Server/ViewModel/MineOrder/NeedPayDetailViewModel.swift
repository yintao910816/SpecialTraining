//
//  NeedPayDetailViewModel.swift
//  SpecialTraining
//
//  Created by sw on 26/06/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class NeedPayDetailViewModel: BaseViewModel, VMNavigation {
    
    private var memberOrder: MemberAllOrderModel!
    
    public let dataSource = Variable([SectionModel<MemberAllOrderModel, OrderItemModel>]())
    public let cancleOrderSubject = PublishSubject<Void>()
    public let gotoPaySubject = PublishSubject<Void>()

    init(memberOrder: MemberAllOrderModel) {
        super.init()
        self.memberOrder = memberOrder
        
        reloadSubject
            .subscribe(onNext: { [weak self] in
                self?.dataSource.value = [SectionModel.init(model: memberOrder, items: memberOrder.orderItem)]
            })
            .disposed(by: disposeBag)
        
        cancleOrderSubject
            .subscribe(onNext: { [unowned self] in
                NoticesCenter.alert(title: "取消订单",
                                    message: "请确认是否要取消订单",
                                    cancleTitle: "取消",
                                    okTitle: "确定")
                {
                    self.requestCancleOrder(orderNo: self.memberOrder.order_number)
                }
            })
            .disposed(by: disposeBag)
        
        gotoPaySubject
            .subscribe(onNext: { [unowned self] in
                let classIds: [String] = self.memberOrder.orderItem.map{ $0.class_id }
                NeedPayDetailViewModel.sbPush("STHome", "PayOrderCtr", parameters: ["classIds": classIds])
            })
            .disposed(by: disposeBag)

    }
    
    /// 取消订单
    private func requestCancleOrder(orderNo: String) {
        hud.noticeLoading()
        STProvider.request(.cancleOrder(order_no: orderNo))
            .mapResponse()
            .asObservable()
            .subscribe(onNext: { [weak self] data in
                self?.hud.successHidden("订单已取消", {
                    self?.popSubject.onNext(Void())
                })
                }, onError: { [weak self] error in
                    self?.hud.failureHidden(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
    }
}
