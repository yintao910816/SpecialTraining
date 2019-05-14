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

class ClassDetailViewModel: BaseViewModel, VMNavigation {
    
    private var classId: String = ""
    private var shopId: String = ""
    
    public let lessonListObser = Variable([ClassListModel]())
    public let classInfoObser = Variable((CourseDetailClassModel(), ShopInfoModel()))

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
                ExpericeCourseDetailViewModel.sbPush("STHome", "verifyCtrlID", parameters: ["classIds": [self.classInfoObser.value.0.class_id]])
            })
            .disposed(by: disposeBag)
    }
    
    private func requestData() {
        hud.noticeLoading()
        
        STProvider.request(.courseClassInfo(classId: classId, shop_id: shopId))
        .map(model: ClassDataModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.lessonListObser.value = data.lessonList
                self?.classInfoObser.value = (data.class_info, data.shop_info)
                
                self?.hud.noticeHidden()
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
        }
        .disposed(by: disposeBag)
    }
    
    private func insertShoppingClass() {
        CourseDetailClassModel.inster(classInfo: classInfoObser.value.0, shopModel: classInfoObser.value.1)
        NotificationCenter.default.post(name: NotificationName.Order.AddOrder, object: classInfoObser.value.0)
        hud.successHidden("添加成功")
    }
}
