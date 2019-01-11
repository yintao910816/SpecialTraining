//
//  WXPayManager.swift
//  SpecialTraining
//
//  Created by yintao on 2019/1/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

enum PayType {
    case wchatPay
    case alipay
}

import Foundation
import RxSwift

class WXPayManager {
    
    private let disposeBag = DisposeBag()
    
    init() {
        NotificationCenter.default.rx.notification(NotificationName.WX.WXPay, object: nil)
            .subscribe(onNext: { no in
               PrintLog(no.object)
            })
            .disposed(by: disposeBag)
    }
    
    func startWchatPay(model: CourseClassModel, shopId: String) {
        STProvider.request(.submitOrder(params: configParams(model: model, shopId: shopId)))
            .map(model: OrderModel.self)
            .asObservable().concatMap{ orderModel in
                STProvider.request(.wxPay(order_number: orderModel.order_number, real_amount: orderModel.real_amount))
                    .map(model: WchatPayModel.self)
            }
            .subscribe(onNext: { payModel in
                if WXApi.send(PayReq.init(model: payModel)) == true {
                    PrintLog("掉起微信支付成功")
                }else {
                    PrintLog("掉起微信支付失败")
                }
            }, onError: { error in
                PrintLog("支付出错：\(error)")
            })
            .disposed(by: disposeBag)
    }
    
    private func configParams(model: CourseClassModel, shopId: String) ->[String: Any] {
        let classInfo: [String: Any] = ["shop_id": shopId,
                                        "class_id": "\(model.class_id)",
                                        "class_num": "1",
                                        "total_money": model.price]
        let params: [String : Any] = ["member_id": userDefault.uid,
                                      "order_total_money": model.price,
                                      "classInfo": [classInfo]]
        
        return params
    }

}
