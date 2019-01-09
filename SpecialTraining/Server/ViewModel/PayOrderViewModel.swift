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

class PayOrderViewModel: BaseViewModel {
    private var model: CourseClassModel!
    private var shopId: String!
    private var payType: PayType = .wchatPay
    
    init(input: (model: CourseClassModel, shopId: String, payType: PayType),
         tap: Driver<Void>) {
        super.init()

        model = input.model
        shopId = input.shopId
        payType  = input.payType
        
        tap.asDriver()
            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] in
                switch self.payType {
                case .wchatPay:
                        self.submitOrder()
                case .alipay:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func submitOrder() {
        
        STProvider.request(.submitOrder(params: configParams()))
            .map(model: OrderModel.self)
            .subscribe(onSuccess: { orderModel in
                self.hud.noticeHidden()
                print(orderModel)
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
        
    }
    
    private func configParams() ->[String: Any] {
        let params: [String : Any] = ["member_id": userDefault.uid,
                                      "order_total_money": model.price,
                                      "classInfo": ["shop_id": shopId!,
                                                    "class_id": "\(model.class_id)",
                                                    "class_num": "\(model.total)",
                                                    "total_money": model.price]]
//        let p: NSDictionary = ["member_id": userDefault.uid,
//                               "order_total_money": model.price,
//                               "classInfo": ["shop_id": shopId!,
//                                             "class_id": "\(model.class_id)"],
//                               "class_num": "\(model.total)",
//            "total_money": model.price]

        
        
        PrintLog(params)
        return params
    }
}
