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
    
    private let wxPayManager = WXPayManager()
    
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
        wxPayManager.startWchatPay(model: model, shopId: shopId)
        
//        STProvider.request(.submitOrder(params: configParams())).map(model: OrderModel.self)
//            .asObservable().concatMap{ orderModel in
//                STProvider.request(.wxPay(order_number: orderModel.order_number, real_amount: orderModel.real_amount))
//                    .map(model: WchatPayModel.self)
//            }
//            .subscribe(onNext: { [weak self] model in
//                self?.hud.noticeHidden()
//
//
//            }, onError: { [weak self] error in
//                self?.hud.failureHidden(self?.errorMessage(error))
//            })
//            .disposed(by: disposeBag)
    }
    
//    private func configParams() ->[String: Any] {
//        let classInfo: [String: Any] = ["shop_id": shopId!,
//                         "class_id": "\(model.class_id)",
//            //                                                    "class_num": "\(model.total)",
//                         "class_num": "1",
//                         "total_money": model.price]
//        let params: [String : Any] = ["member_id": userDefault.uid,
//                                      "order_total_money": model.price,
//                                      "classInfo": [classInfo]]
//
//        return params
//    }
}
