//
//  CourseDetailViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2018/12/14.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class CourseDetailViewModel: BaseViewModel {
    
    private var courseId: String = ""
    
    // 精彩内容
    let splendidnessContentSource = Variable([CourseDetailMediaModel]())
    // 上课音频
    let courseAudioSource = Variable([CourseDetailMediaModel]())
    // 上课时间
    let classTimeSource = Variable([SectionModel<String, ClassTimeItemModel>]())
    // 相关校区
    let relateShopSource = Variable([RelateShopModel]())
    // banner 部分
    let bannerSource = PublishSubject<CourseDetailBannerModel>()
    // 获取班级
    let selecteClassSource = Variable([CourseClassModel]())
    
    init(courseId: String) {
        super.init()
        
        self.courseId = courseId
        
        requestSplendidnessData()
            .subscribe(onNext: { [weak self] datas in
                self?.splendidnessContentSource.value = datas
            }, onError: { [weak self] error in
                PrintLog(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
        
        requestClassTimeData()
            .subscribe(onNext: { [weak self] data in
                self?.dealClassTimeData(data: data)
                }, onError: { [weak self] error in
                    PrintLog(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)

        requestCourseAudioData()
            .subscribe(onNext: { [weak self] datas in
                self?.courseAudioSource.value = datas
                }, onError: { [weak self] error in
                    PrintLog(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)

        requestRelateShopData()
            .subscribe(onNext: { [weak self] datas in
                self?.relateShopSource.value = datas
                }, onError: { [weak self] error in
                    PrintLog(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
        
        requestBannerData()
            .subscribe(onNext: { [weak self] data in
                self?.bannerSource.onNext(data)
                }, onError: { [weak self] error in
                    PrintLog(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
        
        requestClassData()
            .subscribe(onNext: { [weak self] datas in
                datas.first?.isSelected = true
                self?.selecteClassSource.value = datas
                }, onError: { [weak self] error in
                    PrintLog(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
    }
    
    var shopId: String {
        get {
            return relateShopSource.value.first?.shop_id ?? "1"
        }
    }
    
    // 精彩内容
    private func requestSplendidnessData() ->Observable<[CourseDetailMediaModel]> {
        return STProvider.request(.courseVideoOrAudio(course_id: courseId, type: "V"))
            .map(models: CourseDetailMediaModel.self)
            .asObservable()
    }
    
    // 上课时间
    private func requestClassTimeData() ->Observable<ClassTimeModel> {
        return STProvider.request(.classTime(course_id: courseId))
            .map(model: ClassTimeModel.self)
            .asObservable()
    }
    
    // 上课音频
    private func requestCourseAudioData() ->Observable<[CourseDetailMediaModel]> {
        return STProvider.request(.courseVideoOrAudio(course_id: courseId, type: "A"))
            .map(models: CourseDetailMediaModel.self)
            .asObservable()
    }
    
    // 相关校区
    private func requestRelateShopData() ->Observable<[RelateShopModel]> {
        return STProvider.request(.relateShop(course_id: courseId))
            .map(models: RelateShopModel.self)
            .asObservable()
    }
    
    // banner部分
    private func requestBannerData() ->Observable<CourseDetailBannerModel> {
        return STProvider.request(.course(id: courseId))
            .map(model: CourseDetailBannerModel.self)
            .asObservable()
    }
    // 获取班级
    private func requestClassData() ->Observable<[CourseClassModel]> {
        return STProvider.request(.selectClass(course_id: courseId))
            .map(models: CourseClassModel.self)
            .asObservable()
    }
    
    
    private func dealClassTimeData(data: ClassTimeModel) {

        var dealData = [SectionModel<String, ClassTimeItemModel>]()
        
        if data.C.count > 0 {
            let titleString = "    初级（适合人群，有无基础）"
            let sectionData = SectionModel.init(model: titleString, items: data.A)
            dealData.append(sectionData)
        }
       
        if data.B.count > 0 {
            let titleString = "    中级（适合人群，有无基础）"
            let sectionData = SectionModel.init(model: titleString, items: data.A)
            dealData.append(sectionData)
        }

        if data.A.count > 0 {
            let titleString = "    高级（适合人群，有无基础）"
            let sectionData = SectionModel.init(model: titleString, items: data.A)
            dealData.append(sectionData)
        }
        
        classTimeSource.value = dealData
    }
}
