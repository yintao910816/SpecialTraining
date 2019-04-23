//
//  MineOrderViewModel.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/6.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MineOrderViewModel: BaseViewModel {
    
    let totleOrderDatasource   = Variable([SectionModel<MemberAllOrderModel, OrderItemModel>]())
    let needPayOrderDatasource = Variable([SectionModel<MemberAllOrderModel, OrderItemModel>]())
    let hasPayOrderDatasource  = Variable([SectionModel<MemberAllOrderModel, OrderItemModel>]())
    let payBackOrderDatasource = Variable([SectionModel<MemberAllOrderModel, OrderItemModel>]())
    
    let orderOpretionSubject = PublishSubject<(MineOrderFooterOpType, String)>()
    /// 取消退款成功，跳转退款状态界面
    let gotoPayBackDetail = PublishSubject<MemberAllOrderModel>()
    
    override init() {
        super.init()
        
        reloadSubject
            ._doNext(forNotice: hud)
            .flatMap{ [unowned self] in self.loadData() }
            .subscribe(onNext: { [weak self] data in
                self?.dealData(orderModels: data, orderNum: "")
                }, onError: { [weak self] error in
                    self?.hud.failureHidden(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
        
        orderOpretionSubject.subscribe(onNext: { [weak self] data in
            self?.dealOperation(data: data)
        })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.Order.canclePayBack, object: nil)
            ._doNext(forNotice: hud)
            .flatMap{ [unowned self] _ in return self.loadData() }
            .subscribe(onNext: { [weak self] data in
                self?.dealData(orderModels: data, orderNum: "")
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() ->Observable<[MemberAllOrderModel]> {
        return STProvider.request(.getMemberAllOrder(member_id: "100"))
            .map(models: MemberAllOrderModel.self)
            .asObservable()
        //            .subscribe(onSuccess: { [weak self] data in
        //                self?.dealData(orderModels: data)
        //            }) { [weak self] error in
        //                self?.hud.failureHidden(self?.errorMessage(error))
        //            }
        //            .disposed(by: disposeBag)
    }
    
    /// 退款
    private func requestPayBack(orderNo: String, type: MineOrderFooterOpType) {
        hud.noticeLoading()
        STProvider.request(.refundOrder(order_no: orderNo))
            .mapResponse()
            .asObservable()
            .concatMap{ [weak self] res -> Observable<[MemberAllOrderModel]> in
                guard let strongSelf = self else { return Observable.just([MemberAllOrderModel]()) }
                return strongSelf.loadData()
            }
            .subscribe(onNext: { [weak self] data in
                self?.dealData(orderModels: data, remind: "退款成功", type: type, orderNum: orderNo)
                }, onError: { [weak self] error in
                    self?.hud.failureHidden(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
    }
    
    /// 取消退款
    private func requestCanclePayBack(orderNo: String, type: MineOrderFooterOpType) {
        hud.noticeLoading()
        STProvider.request(.canclePayBack(order_no: orderNo))
            .mapResponse()
            .asObservable()
            .concatMap{ [weak self] res -> Observable<[MemberAllOrderModel]> in
                guard let strongSelf = self else { return Observable.just([MemberAllOrderModel]()) }
                return strongSelf.loadData()
            }
            .subscribe(onNext: { [weak self] data in
                self?.dealData(orderModels: data, remind: "已取消退款", type: type, orderNum: orderNo)
                }, onError: { [weak self] error in
                    self?.hud.failureHidden(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
    }
    
    /// 取消订单
    private func requestCancleOrder(orderNo: String, type: MineOrderFooterOpType) {
        hud.noticeLoading()
        STProvider.request(.cancleOrder(order_no: orderNo))
            .mapResponse()
            .asObservable()
            .concatMap{ [weak self] res -> Observable<[MemberAllOrderModel]> in
                guard let strongSelf = self else { return Observable.just([MemberAllOrderModel]()) }
                return strongSelf.loadData()
            }
            .subscribe(onNext: { [weak self] data in
                self?.dealData(orderModels: data, remind: "订单已取消", type: type, orderNum: orderNo)
                }, onError: { [weak self] error in
                    self?.hud.failureHidden(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
    }
    
    private func dealData(orderModels: [MemberAllOrderModel],
                          remind: String? = nil,
                          type: MineOrderFooterOpType? = nil,
                          orderNum: String)
    {
        var totleOrderSectionData   = [SectionModel<MemberAllOrderModel, OrderItemModel>]()
        var needPayOrderSectionData = [SectionModel<MemberAllOrderModel, OrderItemModel>]()
        var hasPayOrderSectionData  = [SectionModel<MemberAllOrderModel, OrderItemModel>]()
        var payBackOrderSectionData = [SectionModel<MemberAllOrderModel, OrderItemModel>]()
        
        for item in orderModels {
            let section = SectionModel<MemberAllOrderModel, OrderItemModel>.init(model: item, items: item.orderItem)
            totleOrderSectionData.append(section)
            switch item.statue {
            case .noPay:
                needPayOrderSectionData.append(section)
            case .haspay:
                hasPayOrderSectionData.append(section)
            case .packBack:
                payBackOrderSectionData.append(section)
            }
        }
        
        totleOrderDatasource.value = totleOrderSectionData
        needPayOrderDatasource.value = needPayOrderSectionData
        hasPayOrderDatasource.value  = hasPayOrderSectionData
        payBackOrderDatasource.value = payBackOrderSectionData
        
        if let msg = remind, let t = type {
            hud.successHidden(msg) { [weak self] in
                if t == .canclePayBack, let memberOrder = orderModels.first(where: { $0.order_number == orderNum }) {
                    self?.gotoPayBackDetail.onNext(memberOrder)
                }
            }
        }else {
            hud.noticeHidden()
        }
    }
}

extension MineOrderViewModel {
    
    private func dealOperation(data: (MineOrderFooterOpType, String)) {
        switch data.0 {
        case .cancleOrder:
            // 取消订单
            NoticesCenter.alert(title: "取消订单", message: "请确认是否要取消订单", cancleTitle: "取消", okTitle: "确定") { [weak self] in
                self?.requestCancleOrder(orderNo: data.1, type: data.0)
            }
        case .goPay:
            // 付款
            break
        case .payBack:
            // 退款
            NoticesCenter.alert(title: "退款", message: "订单尚未完成，即将为您安排上课班级，请确认是否要退款", cancleTitle: "取消", okTitle: "确定") { [weak self] in
                self?.requestPayBack(orderNo: data.1, type: data.0)
            }
        case .inPayBack:
            // 退款中
            if let memberOrder = totleOrderDatasource.value.first(where: { $0.model.order_number == data.1 }) {
                gotoPayBackDetail.onNext(memberOrder.model)
            }
        case .canclePayBack:
            // 取消退款
            NoticesCenter.alert(title: "取消退款", message: "请确认是否要取消退款", cancleTitle: "取消", okTitle: "确定") { [weak self] in
                self?.requestCanclePayBack(orderNo: data.1, type: data.0)
            }
        }
    }
    
}
