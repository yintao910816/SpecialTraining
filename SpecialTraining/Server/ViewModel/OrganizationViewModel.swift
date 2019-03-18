//
//  OrganizationViewModel.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/23.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class OrganizationViewModel: BaseViewModel {
    
    // 广告
    var advListDatasource = Variable([AgencyDetailAdvModel]())
    // 机构首页信息
    var agnInfoDatasource = Variable(OrganazitionShopModel())
    // 课程
    var courseListDatasource = Variable([ShopCourseModel]())
    //
    var teachersDatasource = Variable([ShopTeacherModel]())
        
    var shopId: String!

    init(shopId: String) {
        super.init()
        
        self.shopId = shopId
        
        reloadSubject.subscribe(onNext: { [weak self] _ in
            self?.loadDatas()
        })
            .disposed(by: disposeBag)
    }
    
    private func loadDatas() {
        hud.noticeLoading()
        
        STProvider.request(.shopRead(shopId: shopId))
            .map(model: OrganazitionShopModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.hud.noticeHidden()

                self?.advListDatasource.value = data.advList
                self?.agnInfoDatasource.value = data
                self?.courseListDatasource.value = data.course
                self?.teachersDatasource.value = data.teachers
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
}
