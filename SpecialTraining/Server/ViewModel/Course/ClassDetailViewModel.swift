//
//  ClassDetailViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/4/25.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class ClassDetailViewModel: BaseViewModel, VMNavigation {
    
    private var classId: String = ""
    private var shopId: String = ""
    
    private var classInfo = CourseDetailClassModel()
    private var videoList = [CourseDetailVideoModel]()
    private var randVideoIndex: Int = 0

    public let videoListObser = Variable([SectionModel<CourseDetailClassModel,CourseDetailVideoModel>]())
    public let contentSizeObser = PublishSubject<CGSize>()
    public let changeVideoSubject = PublishSubject<Void>()

    public var shopInfo = ShopInfoModel()
    public var lessionList = [ClassListModel]()
    
    public let playVideoSubject = PublishSubject<CourseDetailVideoModel>()

    let insertShoppingCar = PublishSubject<Void>()
    let buySubject = PublishSubject<Void>()

    init(classId: String, shopId: String) {
        super.init()
        self.classId = classId
        self.shopId  = shopId
        
        reloadSubject
            .subscribe(onNext: { [weak self] _ in  self?.requestData() })
            .disposed(by: disposeBag)
        
        insertShoppingCar
            .subscribe(onNext: { [unowned self] in
                self.insertShoppingClass()
            })
            .disposed(by: disposeBag)
        
        buySubject
            .subscribe(onNext: { [unowned self] in
                self.insertShoppingClass()
                ClassDetailViewModel.sbPush("STHome", "verifyCtrlID", parameters: ["classIds": [self.classInfo.class_id]])
            })
            .disposed(by: disposeBag)
        
        playVideoSubject
            .subscribe(onNext: { model in
                ClassDetailViewModel.sbPush("STHome", "videoPlayCtrl", parameters: ["model": model])
            })
            .disposed(by: disposeBag)
        
        changeVideoSubject
            .subscribe(onNext: { [unowned self] in
                self.randVideoList()
            })
            .disposed(by: disposeBag)
        
        contentSizeObser
            .subscribe(onNext: { [weak self] size in
                guard let strongSelf = self else { return }
                let tempDatas = strongSelf.videoListObser.value
                strongSelf.videoListObser.value = tempDatas
            })
            .disposed(by: disposeBag)
    }
    
    private func requestData() {
        hud.noticeLoading()
        
        STProvider.request(.courseClassInfo(classId: classId, shop_id: shopId))
        .map(model: ClassDataModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.videoList = data.video_list
                self?.classInfo = data.class_info
                self?.classInfo.showChange = !(data.video_list.count > 3)
                self?.classInfo.hasVideo = data.video_list.count > 0
                self?.shopInfo = data.shop_info
                self?.classInfo.lessonName = data.lessonList.first?.name ?? ""
                self?.lessionList = data.lessonList
                
                self?.randVideoList()
                
                self?.hud.noticeHidden()
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
        }
        .disposed(by: disposeBag)
    }
    
    private func insertShoppingClass() {
        CourseDetailClassModel.inster(classInfo: classInfo, shopModel: shopInfo)
        NotificationCenter.default.post(name: NotificationName.Order.AddOrder, object: classInfo)
        hud.successHidden("添加成功")
    }
    
    private func randVideoList() {
        if videoList.count <= 3 {
            videoListObser.value = [SectionModel.init(model: classInfo, items: videoList)]
        }else {
            let endIdx = randVideoIndex + 2
            var tempVides = [CourseDetailVideoModel]()
            if endIdx < videoList.count {
                tempVides = Array(videoList[randVideoIndex...endIdx])
            }else {
                let count = endIdx - (videoList.count - 1)
                tempVides = Array(videoList[randVideoIndex..<videoList.count])
                for idx in 0..<count {
                    tempVides.append(videoList[idx])
                }
            }
            videoListObser.value = [SectionModel.init(model: classInfo, items: tempVides)]

            randVideoIndex += 1
            if randVideoIndex >= videoList.count { randVideoIndex = 0 }
        }
    }
}
