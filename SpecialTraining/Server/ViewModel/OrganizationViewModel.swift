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
    
    // 实体店数据
    var physicalStoreDatasource = Variable([PhysicalStoreModel]())
    // 活动介绍数据
    var activityBrefDatasource = Variable([ActivityBrefModel]())
    // 推荐课程
    var recommendCourseDatasource = Variable([RecommendCourseModel]())
    // 老师风采
    var teachersDatasource = Variable([TeachersModel]())
    
    var agnId: String!

    init(agnId: String) {
        super.init()
        
        self.agnId = agnId

        loadDatas()
    }
    
    private func loadDatas() {

        hud.noticeLoading()
        Observable.zip(physicalStore(), activityBref(), recommendCourse(), teachers(), resultSelector:  { ($0, $1, $2, $3) })
            .subscribe(onNext: { [weak self] (physicalStoreModels, activityBrefModels, recommendCourseModels, teachersModels) in
                self?.physicalStoreDatasource.value = physicalStoreModels
                self?.activityBrefDatasource.value = activityBrefModels
                self?.recommendCourseDatasource.value = recommendCourseModels
                self?.teachersDatasource.value = teachersModels
                self?.hud.noticeHidden()
            })
            .disposed(by: disposeBag)

    }
    
    private func physicalStore() ->Observable<[PhysicalStoreModel]> {
        return STProvider.request(.agnShops(agn_id: agnId))
            .map(model: PhysicalStoreModel.self)
            .map { [$0] }
            .asObservable()
            .catchErrorJustReturn([PhysicalStoreModel]())
    }
    
    private func activityBref() ->Observable<[ActivityBrefModel]> {
        return STProvider.request(.agnActivity(agn_id: agnId))
            .map(models: ActivityBrefModel.self)
            .asObservable()
            .catchErrorJustReturn([ActivityBrefModel]())
    }

    private func recommendCourse() ->Observable<[RecommendCourseModel]> {
        return STProvider.request(.agnCourse(agn_id: agnId))
            .map(models: RecommendCourseModel.self)
            .asObservable()
            .catchErrorJustReturn([RecommendCourseModel]())
    }
    
    private func teachers() ->Observable<[TeachersModel]> {
        return STProvider.request(.agnTeachers(agn_id: agnId))
            .map(models: TeachersModel.self)
            .asObservable()
            .catchErrorJustReturn([TeachersModel]())
    }

}
