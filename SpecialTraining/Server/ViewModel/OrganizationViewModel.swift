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
    var advListDatasource = Variable(AgencyDetailAdvListModel())
    // 机构首页信息
    var agnInfoDatasource = Variable(AgnDetailInfoModel())
    // 课程
    var courseListDatasource = Variable([AgnDetailCourseListModel]())
    // 店铺信息
    var shopListDatasource = Variable([AgnDetailShopListModel]())
    //
    var teachersDatasource = Variable([AgnDetailTeacherModel]())
        
    var agnId: String!

    init(agnId: String) {
        super.init()
        
        self.agnId = agnId
        
        reloadSubject.subscribe(onNext: { [weak self] _ in
            self?.loadDatas()
        })
            .disposed(by: disposeBag)
    }
    
    func getAdvData(selectedIdx: Int) ->[AgencyDetailAdvModel] {
        switch selectedIdx {
        case 0:
            return advListDatasource.value.AI
        case 1:
            return advListDatasource.value.AC
        case 2:
            return advListDatasource.value.AT
        case 3:
            return advListDatasource.value.AS
        default:
            return [AgencyDetailAdvModel]()
        }
    }
    
    private func loadDatas() {

        hud.noticeLoading()
        Observable.zip(agnDetailRequest(), agnTeachersRequest(), resultSelector:  { ($0, $1) })
            .subscribe(onNext: { [weak self] data in
                self?.advListDatasource.value = data.0.advList
                self?.agnInfoDatasource.value = data.0.agn_info
                self?.courseListDatasource.value = data.0.courseList
                
                self?.teachersDatasource.value = data.1
                
                self?.hud.noticeHidden()
            })
            .disposed(by: disposeBag)

    }
    
    private func agnDetailRequest() ->Observable<AgencyDetailModel>{
        return STProvider.request(.agencyDetail(id: agnId))
            .map(model: AgencyDetailModel.self)
            .asObservable()
            .catchErrorJustReturn(AgencyDetailModel())
    }
    
    private func agnTeachersRequest() ->Observable<[AgnDetailTeacherModel]>{
        return STProvider.request(.agnTeachers(agnId: agnId))
            .map(models: AgnDetailTeacherModel.self)
            .asObservable()
            .catchErrorJustReturn([AgnDetailTeacherModel]())
    }
    
//    private func physicalStore() ->Observable<[PhysicalStoreModel]> {
//        return STProvider.request(.agnShops(agn_id: agnId))
//            .map(model: PhysicalStoreModel.self)
//            .map { [$0] }
//            .asObservable()
//            .catchErrorJustReturn([PhysicalStoreModel]())
//    }
//
//    private func activityBref() ->Observable<[ActivityBrefModel]> {
//        return STProvider.request(.agnActivity(agn_id: agnId))
//            .map(models: ActivityBrefModel.self)
//            .asObservable()
//            .catchErrorJustReturn([ActivityBrefModel]())
//    }
//
//    private func recommendCourse() ->Observable<[RecommendCourseModel]> {
//        return STProvider.request(.agnCourse(agn_id: agnId))
//            .map(models: RecommendCourseModel.self)
//            .asObservable()
//            .catchErrorJustReturn([RecommendCourseModel]())
//    }
//
//    private func teachers() ->Observable<[TeachersModel]> {
//        return STProvider.request(.agnTeachers(agn_id: agnId))
//            .map(models: TeachersModel.self)
//            .asObservable()
//            .catchErrorJustReturn([TeachersModel]())
//    }

}
