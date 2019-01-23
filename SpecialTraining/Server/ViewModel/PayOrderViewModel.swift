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
    private var payType: PayType = .wchatPay
    
    private let wxPayManager = WXPayManager()
    
    let priceTextObser = Variable(NSAttributedString.init(string: ""))
    
    init(input: (models: [CourseClassModel], payType: PayType),
         tap: Driver<Void>) {
        super.init()

        models = input.models
        payType  = input.payType
        
        caculatePrice()
        
        tap.asDriver()._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] in
                switch self.payType {
                case .wchatPay:
                        self.submitOrder()
                case .alipay:
                    PrintLog("开始支付宝支付")
                }
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(NotificationName.WX.WXPay, object: nil)
            .subscribe(onNext: { [weak self] no in
                if let ret = no.object as? (Bool, String) {
                    if ret.0 == true {
                        self?.hud.noticeHidden()
                        self?.pushNextSubject.onNext(Void())
                    }else {
                        self?.hud.failureHidden(ret.1)
                    }
                }else {
                    self?.hud.noticeHidden()
                }
            })
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
    
    private func submitOrder() {
        wxPayManager.startWchatPay(models: models)
    }
}
