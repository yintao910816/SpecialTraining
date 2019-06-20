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

class HomeViewModel: BaseViewModel, VMNavigation {
   
    let nearByCourseViewModel       = HomeNearByCourseViewModel()
    let expericeCourseViewModel     = HomeExperienceCourseViewModel()
    let nearByOrgnazitionViewModel  = HomenNearByOrgnazitionViewModel()
    
    let clickedIconSubject = PublishSubject<HomeNearbyCourseItemModel>()
    
    let navigationItemTitle = Variable((false, "荆州市"))
    
    override init() {
        super.init()
        
//        NotificationCenter.default.rx.notification(NotificationName.BMK.RefreshHomeLocation, object: nil)
//            .subscribe(onNext: { no in
//                BMKGeoCodeSearchHelper.share.startReverseGeoCode(coordinate: no.object as! CLLocationCoordinate2D)
//            })
//            .disposed(by: disposeBag)
//
//        BMKGeoCodeSearchHelper.share.reverseGeoObser
//            .subscribe(onNext: { [unowned self] (result, flag, message) in
//                self.navigationItemTitle.value = (false, result.addressDetail.city)
//            })
//            .disposed(by: disposeBag)
//
//        NotificationCenter.default.rx.notification(NotificationName.BMK.LoadHomeData, object: nil)
//            .subscribe(onNext: { [unowned self] no in
//                self.loadDatas()
//            })
//            .disposed(by: disposeBag)
//
//        NotificationCenter.default.rx.notification(NotificationName.BMK.BMKSetupFail, object: nil)
//            .subscribe(onNext: { [unowned self] no in
//                self.loadDatas()
//            })
//            .disposed(by: disposeBag)

        reloadSubject
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] _ in
                self.loadDatas()
            })
            .disposed(by: disposeBag)
        
        clickedIconSubject
            .subscribe(onNext: { model in
                HomeViewModel.sbPush("STHome", "ShopInfoSegue", parameters: ["shop_id": model.shop_id])
            })
            .disposed(by: disposeBag)

    }
    
    // 加载所有数据
    private func loadDatas() {
        Observable.zip(nearByCourseViewModel.nearByCourse(),
                       expericeCourseViewModel.activityCourse(),
                       nearByOrgnazitionViewModel.nearByOrganization(), resultSelector:  { ($0, $1, $2) })
            .subscribe(onNext: { [unowned self] (nearByCourseModel, experienceCourseModel, nearByOrganizationModel) in
                //
                self.nearByCourseViewModel.dealData(data: nearByCourseModel)
                //
                self.expericeCourseViewModel.dealData(data: experienceCourseModel)
                //
                self.nearByOrgnazitionViewModel.dealData(data: nearByOrganizationModel)
                
                self.hud.noticeHidden()
                }, onError: { [weak self] error in
                    self?.hud.failureHidden(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
    }
    
}


class HomeNearByCourseViewModel: RefreshVM<NearCourseListModel> {

    let nearByCourseSourse = Variable(([SectionModel<Int, HomeCellSize>](), [AdvertListModel]()))

    override init() {
        super.init()
        
    }
    
    override func requestData(_ refresh: Bool) {
        setOffset(refresh: refresh)

        nearByCourse(offset: pageModel.offset)
            .subscribe(onNext: { [weak self] data in
                self?.dealData(data: data)
            }, onError: { [weak self] error in
                self?.hud.failureHidden("nearCourse：\(self?.errorMessage(error) ?? "")")
            })
            .disposed(by: disposeBag)
    }
    
    func nearByCourse(offset: Int = 0) ->Observable<DataModel<HomeNearbyCourseModel>> {
        return STProvider.request(.nearCourse(lat: userDefault.lat, lng: userDefault.lng, offset: offset))
            .map(result: HomeNearbyCourseModel.self)
            .asObservable()
//            .catchErrorJustReturn(DataModel<HomeNearbyCourseModel>())
    }
    
    func dealData(data: DataModel<HomeNearbyCourseModel>) {
        guard let sourceData = data.data else {
            updateRefresh(true, [NearCourseListModel](), 0)
            nearByCourseSourse.value = ([SectionModel<Int, HomeCellSize>](), [AdvertListModel]())
            return
        }
        var sectionData: [SectionModel<Int, HomeCellSize>] = []
        
        for item in sourceData.nearCourseList {
            if item.course.count > 0 {
                item.course[0].shop_id   = item.shop_id
                item.course[0].shop_name = item.shop_name
                item.course[0].shop_logo = item.shop_logo
                item.course[0].dis       = item.dis
                item.course[0].showCellImg = true
                sectionData.append(SectionModel.init(model: 0, items: item.course))
                continue
            }
        }
        
        nearByCourseSourse.value = (sectionData, sourceData.advertList)
        
        updateRefresh(true, sourceData.nearCourseList, data.total)
    }

}

class HomeExperienceCourseViewModel: RefreshVM<ExperienceCourseItemModel> {
    
    let experienceCourseSourse = Variable(([SectionModel<Int, HomeCellSize>](), [AdvertListModel]()))
    
    override init() {
        super.init()
        
    }
    
    override func requestData(_ refresh: Bool) {
        setOffset(refresh: refresh)

        activityCourse(offset: pageModel.offset)
            .subscribe(onNext: { [unowned self] data in
                self.dealData(data: data)
                }, onError: { [weak self] error in
                    self?.hud.failureHidden("activityCourse：\(self?.errorMessage(error) ?? "")")
            })
            .disposed(by: disposeBag)
    }
    
    func activityCourse(offset: Int = 0) ->Observable<ExperienceCourseModel> {
        return STProvider.request(.activityCourse(offset: offset))
            .map(model: ExperienceCourseModel.self)
            .asObservable()
//            .catchErrorJustReturn(ExperienceCourseModel())
    }

    func dealData(data: ExperienceCourseModel) {
        updateRefresh(true, data.courseList, data.total)
        
        let tempData = ([SectionModel.init(model: 0, items: datasource.value as [HomeCellSize])], data.advertList)
        
        experienceCourseSourse.value = tempData
    }
    
}


class HomenNearByOrgnazitionViewModel: RefreshVM<NearByOrganizationItemModel> {
    
    let nearByOrgnazitionSourse = Variable(([NearByOrganizationItemModel](), [AdvertListModel]()))
    
    override init() {
        super.init()
        
    }
    
    override func requestData(_ refresh: Bool) {
        setOffset(refresh: refresh)
        
        nearByOrganization(offset: pageModel.offset)
            .subscribe(onNext: { [unowned self] data in
                self.dealData(data: data)
                }, onError: { [weak self] error in
                    self?.hud.failureHidden("agency：\(self?.errorMessage(error) ?? "")")
            })
            .disposed(by: disposeBag)
    }
    
    func nearByOrganization(offset: Int = 0) ->Observable<NearByOrganizationModel> {
        return STProvider.request(.agency(lat: userDefault.lat, lng: userDefault.lng, offset: offset))
            .map(model: NearByOrganizationModel.self)
            .asObservable()
//            .catchErrorJustReturn(NearByOrganizationModel())
    }

    func dealData(data: NearByOrganizationModel) {
        updateRefresh(true, data.agnList, data.total)
        
        let tempData = (datasource.value, data.advertList)
        
        nearByOrgnazitionSourse.value = tempData
    }

}
