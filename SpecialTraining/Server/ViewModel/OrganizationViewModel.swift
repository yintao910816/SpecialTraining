//
//  OrganizationViewModel.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/23.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class OrganizationViewModel: BaseViewModel, VMNavigation {
    
//    // 广告
//    var advListDatasource = Variable([AgencyDetailAdvModel]())
//    // 机构首页信息
//    var agnInfoDatasource = Variable(OrganazitionShopModel())
//    // 课程
//    var courseListDatasource = Variable([ShopCourseModel]())
//    //
//    var teachersDatasource = Variable([ShopTeacherModel]())

    /// 课程广告
    var advListDatasource = Variable([ShopDetailAdvModel]())
    /// 机构首页信息
    var agnInfoDatasource = Variable(ShopDetailModel())
    /// 课程
    var courseListDatasource = Variable([ShopDetailCourseModel]())
    /// 师资
    var teachersDatasource = Variable([ShopDetailTeacherModel]())

    var logoObser = Variable("")
    var navTitleObser = Variable("")

    /// 跳转课程详情
    let gotoCourdetailSubject = PublishSubject<ShopDetailCourseModel>()

    private var shopId: String!

    init(shopId: String, locationAction: Driver<Void>) {
        super.init()
        
        self.shopId = shopId
        
        reloadSubject.subscribe(onNext: { [weak self] _ in
            self?.loadDatas()
        })
            .disposed(by: disposeBag)
        
        gotoCourdetailSubject
            .subscribe(onNext: { model in
                OrganizationViewModel.sbPush("STHome", "courseDetailCtrl", parameters: ["course_id": model.course_id])
            })
            .disposed(by: disposeBag)
    }
    
    func getCoorInfo() ->[String: Double?] {
        let lat = Double(agnInfoDatasource.value.lat)
        let lng = Double(agnInfoDatasource.value.lng)
        return ["lat": lat, "lng": lng]
    }
    
    private func loadDatas() {
        hud.noticeLoading()
        
        STProvider.request(.shopRead(shopId: shopId))
            .map(model: ShopDetailModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.advListDatasource.value = data.advList
                self?.agnInfoDatasource.value = data
                self?.courseListDatasource.value = data.course
                self?.teachersDatasource.value = data.teachers
                
                self?.logoObser.value = data.logo
                self?.navTitleObser.value = data.shop_name
                
                self?.hud.noticeHidden()

            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
}
