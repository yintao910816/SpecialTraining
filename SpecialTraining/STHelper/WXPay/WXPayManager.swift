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
    
    func startWchatPay(model: CourseClassModel, hud: NoticesCenter) {
        STProvider.request(.submitOrder(params: configParams(model: model, shopId: model.shop_id)))
//            .map(model: OrderModel.self)
            .asObservable().concatMap{ res ->Observable<WchatPayModel> in
                guard let jsonDictionary = try res.mapJSON() as? NSDictionary else {
                    hud.failureHidden("接口解析失败")
                    throw MapperError.json(message: "json解析失败")
                }
                guard let orderNum = jsonDictionary.value(forKeyPath: "data") as? String else {
                    hud.failureHidden("接口解析失败")
                    return Observable.just(WchatPayModel())
                }
                return STProvider.request(.wxPay(order_number: orderNum, real_amount: "0.1"))
                    .map(model: WchatPayModel.self)
                    .asObservable()
            }
            .subscribe(onNext: { [weak self] model in

                if WXApi.send(self?.creatPayModel(model: model)) == true {
                    PrintLog("掉起微信支付成功")
                    hud.noticeHidden()
                }else {
                    PrintLog("掉起微信支付失败")
                    hud.failureHidden("参数错误")
                }
            }, onError: { error in
                PrintLog("支付出错：\(error)")
                hud.failureHidden("\(error)")
            })
            .disposed(by: disposeBag)
    }
    
    private func creatPayModel(model: WchatPayModel) ->PayReq {
        let req = PayReq()
        req.openID = model.appid
        req.partnerId = model.partnerId
        req.prepayId = model.prepayId
        req.nonceStr = model.nonceStr
        req.timeStamp = UInt32(model.timeStamp)!
        req.package = model.package
        req.sign    = model.sign
       
        return req
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
