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
    private var models: [CourseClassModel]!
    
    private let payManager = AppPayManager()
    
    let priceTextObser = Variable(NSAttributedString.init(string: ""))
    
    init(models: [CourseClassModel], tap: Driver<PayType>) {
        super.init()

        self.models = models
        
        caculatePrice()
        
        tap.asDriver()._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] type in
                switch type {
                case .wchatPay:
                    self.payManager.startWchatPay(models: self.models)
                case .alipay:
                    self.payManager.startAliPay(models: self.models)
                }
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(NotificationName.WX.WXPay, object: nil)
            .subscribe(onNext: { [weak self] no in self?.finishPay(result: no.object) })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.AliPay.aliPayBack, object: nil)
            .subscribe(onNext: { [weak self] no in self?.finishPay(result: no.object) })
            .disposed(by: disposeBag)
    }
    
    private func caculatePrice() {
        var totlePrice: Double = 0.0
        for course in models {
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
}
