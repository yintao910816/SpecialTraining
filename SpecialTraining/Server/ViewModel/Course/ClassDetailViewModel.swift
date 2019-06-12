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

    public let videoListObser = Variable([SectionModel<CourseDetailClassModel,CourseDetailVideoModel>]())
    public let contentSizeObser = PublishSubject<CGSize?>()

    public var shopInfo = ShopInfoModel()
    
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
        
        contentSizeObser
            .subscribe(onNext: { [weak self] size in
                guard let strongSelf = self else { return }
                if let _zize = size {
                    let tempDatas = strongSelf.videoListObser.value
                    strongSelf.videoListObser.value = tempDatas
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func requestData() {
        hud.noticeLoading()
        
        STProvider.request(.courseClassInfo(classId: classId, shop_id: shopId))
        .map(model: ClassDataModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.videoListObser.value = [SectionModel.init(model: data.class_info, items: data.video_list)]
                self?.classInfo = data.class_info
                self?.shopInfo = data.shop_info
                
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
}
