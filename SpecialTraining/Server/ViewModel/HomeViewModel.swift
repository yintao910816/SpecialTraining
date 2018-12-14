//
//  HomeViewModel.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class HomeViewModel: BaseViewModel {
   
    let colDatasource = Variable([SectionModel<Int, HomeCellSize>]())
    let tabviewDatasource = Variable([OrganizationModel]())
    
    let navigationItemTitle = Variable((false, "荆州市"))
    
    override init() {
        super.init()
        
        self.tabviewDatasource.value = [OrganizationModel(), OrganizationModel(), OrganizationModel(), OrganizationModel()]

        NotificationCenter.default.rx.notification(NotificationName.BMK.RefreshHomeLocation, object: nil)
            .subscribe(onNext: { no in
                BMKGeoCodeSearchHelper.share.startReverseGeoCode(coordinate: no.object as! CLLocationCoordinate2D)
            })
            .disposed(by: disposeBag)
        
        BMKGeoCodeSearchHelper.share.reverseGeoObser
            .subscribe(onNext: { [unowned self] (result, flag, message) in
                self.navigationItemTitle.value = (false, result.addressDetail.city)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.BMK.LoadHomeData, object: nil)
            .subscribe(onNext: { [unowned self] no in
                self.loadDatas()
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.BMK.BMKSetupFail, object: nil)
            .subscribe(onNext: { [unowned self] no in
                self.loadDatas()
            })
            .disposed(by: disposeBag)

    }
    
    // 加载所有数据
    private func loadDatas() {
//        Observable.combineLatest(nearByCourse(), activityCourse())
//            .subscribe(onNext: { [unowned self] (nearByDatas, activityDatas) in
//                let experienceCourseModels: [HomeCellSize] = activityDatas
//                let nearByCourseModels: [HomeCellSize] = nearByDatas
//                let optimizationCourseModels: [HomeCellSize] = [OptimizationCourseModel(),
//                                                                OptimizationCourseModel()]
//
//                let configData = [SectionModel.init(model: 0, items: experienceCourseModels),
//                                  SectionModel.init(model: 0, items: nearByCourseModels),
//                                  SectionModel.init(model: 0, items: optimizationCourseModels)]
//                self.colDatasource.value = configData
//
//                self.hud.noticeHidden()
//                }, onError: { [unowned self] error in
//                    self.hud.failureHidden(self.errorMessage(error))
//            })

//        colDatasource.value = [SectionModel.init(model: 0, items: [ExperienceCourseModel(),
//                                                                   ExperienceCourseModel(),
//                                                                   ExperienceCourseModel(),
//                                                                   ExperienceCourseModel()]),
//                               SectionModel.init(model: 1, items: NearByCourseModel.testDatas()),
//                               SectionModel.init(model: 2, items: [OptimizationCourseModel(), OptimizationCourseModel(), OptimizationCourseModel()])]

        colDatasource.value = [SectionModel.init(model: 1, items: NearByCourseModel.testDatas())]

    }
    
    // 附近课程
    private func nearByCourse() ->Observable<[NearByCourseModel]> {
        return STProvider.request(.nearCourse(lat: userDefault.lat, lng: userDefault.lng))
            .map(models: NearByCourseModel.self)
            .asObservable()
    }
    
    // 体验专区
    private func activityCourse() ->Observable<[ExperienceCourseModel]> {
        return STProvider.request(.activityCourse())
            .map(models: ExperienceCourseModel.self)
            .asObservable()
    }
}
