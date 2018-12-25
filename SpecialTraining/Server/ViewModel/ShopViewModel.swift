//
//  ShopViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2018/12/25.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class ShopViewModel: BaseViewModel {
    
    // 活动介绍数据
    var activityBrefDatasource = Variable([ActivityBrefModel]())
    // 推荐课程
    var recommendCourseDatasource = Variable([RecommendCourseModel]())
    // 老师风采
    var teachersDatasource = Variable([TeachersModel]())
    
    var shopId: String!
    
    init(shopId: String) {
        super.init()
        
        self.shopId = shopId
        
        loadDatas()
    }
    
    private func loadDatas() {
        
        hud.noticeLoading()
        Observable.zip(activityBref(), recommendCourse(), teachers(), resultSelector:  { ($0, $1, $2) })
            .subscribe(onNext: { [weak self] (activityBrefModels, recommendCourseModels, teachersModels) in
                self?.activityBrefDatasource.value = activityBrefModels
                self?.recommendCourseDatasource.value = recommendCourseModels
                self?.teachersDatasource.value = teachersModels
                self?.hud.noticeHidden()
            })
            .disposed(by: disposeBag)
        
    }
    
    private func activityBref() ->Observable<[ActivityBrefModel]> {
        return STProvider.request(.shopActivity(shop_id: shopId))
            .map(models: ActivityBrefModel.self)
            .asObservable()
            .catchErrorJustReturn([ActivityBrefModel]())
    }
    
    private func recommendCourse() ->Observable<[RecommendCourseModel]> {
        return STProvider.request(.shopCourse(shop_id: shopId))
            .map(models: RecommendCourseModel.self)
            .asObservable()
            .catchErrorJustReturn([RecommendCourseModel]())
    }
    
    private func teachers() ->Observable<[TeachersModel]> {
        return STProvider.request(.shopTeachers(shop_id: shopId))
            .map(models: TeachersModel.self)
            .asObservable()
            .catchErrorJustReturn([TeachersModel]())
    }
    
}
