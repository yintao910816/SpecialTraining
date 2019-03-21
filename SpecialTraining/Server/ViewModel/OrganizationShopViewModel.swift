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
    var agnLogoObser = Variable("")
    var navTitleObser = Variable("")

    init(agnId: String) {
        super.init()
        
        self.agnId = agnId
        
        reloadSubject.subscribe(onNext: { [weak self] in
            self?.requestShopData()
        })
            .disposed(by: disposeBag)
    }
    
    private func requestShopData() {
        hud.noticeLoading()
        
        STProvider.request(.agnShop(id: agnId))
            .map(model: OrganzationModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.datasource.value = data.shopList
                self?.advDatasource.value = data.advList
                self?.agnLogoObser.value = data.agn_info.logo
                self?.navTitleObser.value = data.agn_info.agn_name
                self?.hud.noticeHidden()
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
}
