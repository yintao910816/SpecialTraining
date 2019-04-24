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
    
    let courseInfoDataSource = Variable(CourseDetailInfoModel())
    let videoDatasource = Variable([CourseDetailVideoModel]())
    let audioDatasource = Variable([CourseDetailAudioModel]())
    let classDatasource = Variable([CourseDetailClassModel]())
    
    let requestAudioSource = PublishSubject<CourseDetailAudioModel>()
    let audioSourceChange = PublishSubject<String>()
    // 获取班级
    let selecteClassSource = Variable([CourseClassModel]())
    
    init(courseId: String) {
        super.init()
        
        self.courseId = courseId
        
        reloadSubject
            .subscribe(onNext: { [weak self] _ in  self?.requestData() })
            .disposed(by: disposeBag)
        
        requestAudioSource
            .subscribe(onNext: { [weak self] model in
                self?.requestAudio(model: model)
            })
            .disposed(by: disposeBag)
        
    }
    
    var shopId: String {
        get {
            return "1"
        }
    }
    
    // 获取班级
    private func requestClassData() {
        STProvider.request(.selectClass(course_id: courseId))
            .map(models: CourseClassModel.self)
            .subscribe(onSuccess: { [weak self] datas in
                datas.first?.isSelected = true
                self?.selecteClassSource.value = datas
                }, onError: { [weak self] error in
                    PrintLog(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
    }
    
    private func requestData() {
        hud.noticeLoading()
        
        STProvider.request(.courseDetail(id: courseId))
            .map(model: CourseDetailModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.courseInfoDataSource.value = data.course_info
                self?.videoDatasource.value = data.videoList
                self?.audioDatasource.value = data.audioList
                self?.classDatasource.value = data.classList
                self?.hud.noticeHidden()
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
    private func requestAudio(model: CourseDetailAudioModel) {
        if let audioPath = FileHelper.share.getLocalMediaPath(type: .audio, url: model.res_url.md5) {
            audioSourceChange.onNext(audioPath)
        }else {
            hud.noticeLoading()

            STProvider.requestWithProgress(.downLoad(url: model.res_url, mediaType: .audio))
                .do(onNext: { [weak self] res in
                    PrintLog("音乐下载进度：\(res.progress)")
                    if res.progress == 1 {
                        self?.hud.noticeHidden()
                    }
                    }, onError: { [weak self] erro in
                        self?.hud.failureHidden(self?.errorMessage(erro))
                })
                .filter{ res ->Bool in
                    if FileHelper.share.getLocalMediaPath(type: .audio, url: model.res_url.md5) != nil && res.progress == 1{
                        PrintLog("音频文件存在")
                        return true
                    }
                    PrintLog("音频文件不存在")
                    return false
                }
                .map{ _ in FileHelper.share.getCachePath(type: .audio) + model.res_url.md5 }
                .asObservable()
                .bind(to: audioSourceChange)
                .disposed(by: disposeBag)
        }
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
        
//        classTimeSource.value = dealData
    }
}

extension CourseDetailViewModel {
    
    public func getShopID() ->String { return courseInfoDataSource.value.shop_id }
}
