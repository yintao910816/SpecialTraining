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
    
    let dataSource = Variable([SectionModel<Int, OrderItemModel>]())
    let detailInfoObser = Variable(RefundDetailsModel())
    let canclePayBack = PublishSubject<Void>()
    
    private var memberOrder: MemberAllOrderModel!
    
    init(memberOrder: MemberAllOrderModel) {
        super.init()
        
        dataSource.value = [SectionModel.init(model: 0, items: memberOrder.orderItem)]
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
                self?.detailInfoObser.value = model
                self?.hud.noticeHidden()
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
}
