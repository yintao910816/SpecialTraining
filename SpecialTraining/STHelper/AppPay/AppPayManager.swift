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

class AppPayManager {
    
    private let disposeBag = DisposeBag()
    
    func startWchatPay(models: [CourseClassModel]) {
        STProvider.request(.submitOrder(params: configParams(models: models)))
            .map(model: OrderModel.self)
            .asObservable().concatMap{ model ->Observable<WchatPayModel> in
                return STProvider.request(.wxPay(order_number: model.order_number, real_amount: model.real_amount))
                    .map(model: WchatPayModel.self)
                    .asObservable()
            }
            .subscribe(onNext: { [weak self] model in
                if WXApi.send(self?.creatPayModel(model: model)) == false {
                    NotificationCenter.default.post(name: NotificationName.WX.WXPay, object: (false, "调起微信支付失败！"))
                }
            }, onError: { error in
                NotificationCenter.default.post(name: NotificationName.WX.WXPay, object: (false, error.localizedDescription))
            })
            .disposed(by: disposeBag)
    }
    
    func startAliPay(models: [CourseClassModel]) {
        STProvider.request(.submitOrder(params: configParams(models: models)))
            .map(model: OrderModel.self)
            .asObservable().concatMap{ model ->Observable<String> in
                return STProvider.request(.alipay(order_number: model.order_number))
                    .map({ response -> String in
                        
                        guard let jsonData = try JSONSerialization.jsonObject(with: response.data,
                                                                              options: .mutableContainers) as? [String: Any]  else {
                            return ""
                        }
                        
                        guard let payStr = jsonData["data"] as? String else {
                            return ""
                        }
                        return payStr
                    })
                    .asObservable()
            }
            .subscribe(onNext: { orderString in
                if orderString.count > 0 {
                    AlipaySDK.defaultService()?.payOrder(orderString, fromScheme: "specialTraining.youpeixun.com", callback: { resultDic in

                    })
                }else {
                    NotificationCenter.default.post(name: NotificationName.AliPay.aliPayBack, object: (false, "支付信息后获取失败"))
                }
            }, onError: { error in
                NotificationCenter.default.post(name: NotificationName.AliPay.aliPayBack, object: (false, error.localizedDescription))
            })
            .disposed(by: disposeBag)
    }
    
}

extension AppPayManager {
    
    private func creatPayModel(model: WchatPayModel) ->PayReq {
        let req = PayReq()
        req.openID = model.partnerId // "1521169891"
        req.partnerId = model.partnerId
        req.prepayId = model.prepayId
        req.nonceStr = model.nonceStr
        req.timeStamp = UInt32(model.timeStamp) ?? 0
        req.package = model.package
        req.sign    = model.sign
        
        return req
    }
    
    private func configParams(models: [CourseClassModel]) ->[String: Any] {
        var classInfos = [[String: Any]]()
        var totleMoney: Double = 0.0
        for course in models {
            let classInfo: [String: Any] = ["shop_id": course.shop_id,
                                            "class_id": "\(course.class_id)",
                "class_num": "1",
                "total_money": course.price]
            classInfos.append(classInfo)
            
            totleMoney += (Double(course.price) ?? 0.0)
        }
        let params: [String : Any] = ["member_id": userDefault.uid,
                                      "order_total_money": totleMoney,
                                      "classInfo": classInfos]
        
        return params
    }

}