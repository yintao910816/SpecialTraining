//
//  NeedPayDetailViewModel.swift
//  SpecialTraining
//
//  Created by sw on 26/06/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class NeedPayDetailViewModel: BaseViewModel {
    
    private var memberOrder: MemberAllOrderModel!
    
    let dataSource = Variable([SectionModel<MemberAllOrderModel, OrderItemModel>]())

    init(memberOrder: MemberAllOrderModel) {
        super.init()
        self.memberOrder = memberOrder
        
        reloadSubject
            .subscribe(onNext: { [weak self] in
                self?.dataSource.value = [SectionModel.init(model: memberOrder, items: memberOrder.orderItem)]
            })
            .disposed(by: disposeBag)
    }
    
}
