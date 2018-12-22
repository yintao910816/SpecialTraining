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
   
    let nearByCourseSourse = Variable(([SectionModel<Int, HomeCellSize>](), [AdvertListModel]()))
    let expericeDatasource = Variable(([SectionModel<Int, HomeCellSize>](), [AdvertListModel]()))
    let nearByOrgnazitionSource  = Variable(([NearByOrganizationItemModel](), [AdvertListModel]()))
    
    let navigationItemTitle = Variable((false, "荆州市"))
    
    override init() {
        super.init()
        
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
        hud.noticeLoading()
        
        Observable.zip(nearByCourse(), activityCourse(), nearByOrganization(), resultSelector:  { ($0, $1, $2) })
            .subscribe(onNext: { [unowned self] (nearByCourseModel, experienceCourseModel, nearByOrganizationModel) in
                //
                self.nearByCourseSourse.value = ([SectionModel.init(model: 0, items: nearByCourseModel.nearCourseList)], nearByCourseModel.advertList)
                //
                self.expericeDatasource.value = ([SectionModel.init(model: 0, items: experienceCourseModel.courseList)], experienceCourseModel.advertList)
                //
                self.nearByOrgnazitionSource.value = (nearByOrganizationModel.agnList, nearByOrganizationModel.advertList)
                
                self.hud.noticeHidden()
            })
            .disposed(by: disposeBag)
    }
    
    private func nearByCourse() ->Observable<NearByCourseModel> {
        return STProvider.request(.nearCourse(lat: userDefault.lat, lng: userDefault.lng, offset: 0))
            .map(model: NearByCourseModel.self)
            .asObservable()
            .catchErrorJustReturn(NearByCourseModel())
    }
    
    private func activityCourse() ->Observable<ExperienceCourseModel> {
        return STProvider.request(.activityCourse(offset: 0))
            .map(model: ExperienceCourseModel.self)
            .asObservable()
            .catchErrorJustReturn(ExperienceCourseModel())
    }
    
    private func nearByOrganization() ->Observable<NearByOrganizationModel> {
        return STProvider.request(.agency(lat: userDefault.lat, lng: userDefault.lng, offset: 0))
            .map(model: NearByOrganizationModel.self)
            .asObservable()
            .catchErrorJustReturn(NearByOrganizationModel())
    }
    
}
