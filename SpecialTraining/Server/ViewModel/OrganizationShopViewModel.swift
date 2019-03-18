//
//  OrganizationShopView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/16.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class OrganizationShopViewModel: BaseViewModel {

    private var agnId: String = ""
    
    var datasource = Variable([OrganazitonShopModel]())
    var advDatasource = Variable([AgencyDetailAdvModel]())

    var shopListDatasource = Variable([OrganazitonShopModel]())

    init(agnId: String) {
        super.init()
        
        self.agnId = agnId
        
        reloadSubject.subscribe(onNext: { [weak self] in
            self?.requestShopData()
        })
            .disposed(by: disposeBag)
    }
    
    private func requestShopData() {
        STProvider.request(.agnShop(id: agnId))
            .map(model: OrganzationModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.datasource.value = data.shopList
                self?.advDatasource.value = data.advList
            }) { error in
                
            }
            .disposed(by: disposeBag)
    }
    
}
