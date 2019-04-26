//
//  PayOrderViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/1/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PayOrderViewModel: BaseViewModel, VMNavigation {
    private var orderModels: [CourseDetailClassModel] = []
    private var classIds: [String] = []
    
    private let payManager = AppPayManager()
    
    let priceTextObser = Variable(NSAttributedString.init(string: ""))
    
    init(classIds: [String], tap: Driver<PayType>) {
        super.init()

        self.classIds = classIds
        
        tap.asDriver()._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] type in
                switch type {
                case .wchatPay:
                    self.payManager.startWchatPay(models: self.orderModels)
                case .alipay:
                    self.payManager.startAliPay(models: self.orderModels)
                }
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(NotificationName.WX.WXPay, object: nil)
            .subscribe(onNext: { [weak self] no in self?.finishPay(result: no.object) })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.AliPay.aliPayBack, object: nil)
            .subscribe(onNext: { [weak self] no in self?.finishPay(result: no.object) })
            .disposed(by: disposeBag)
        
        loadDbOrder()
    }
    
    private func caculatePrice() {
        var totlePrice: Double = 0.0
        for course in orderModels {
            totlePrice += (Double(course.price) ?? 0)
        }
        
        let priceText = "￥\(totlePrice)"

        priceTextObser.value = priceText.attributed([NSRange.init(location: 0, length: 1)],
                                                    font: [UIFont.systemFont(ofSize: 13)])
    }
 
    private func finishPay(result: Any?) {
        if let ret = result as? (Bool, String) {
            if ret.0 == true {
                hud.noticeHidden()
                pushNextSubject.onNext(Void())
            }else {
                hud.failureHidden(ret.1)
            }
        }else {
            hud.noticeHidden()
        }
    }
    
    private func loadDbOrder() {
        if classIds.count > 0 {
            CourseDetailClassModel.selectedOrderClass(classIds: classIds)
                .subscribe(onNext: { [weak self] datas in
                    self?.orderModels = datas
                    self?.caculatePrice()
                })
                .disposed(by: disposeBag)
            
        }
    }
}
