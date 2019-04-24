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

class ClassDetailViewModel: BaseViewModel {
    
    private var classId: String = ""
    private var shopId: String = ""
    
    public let lessonListObser = Variable([ClassListModel]())
    public let classInfoObser = Variable((ClassInfoModel(), ShopInfoModel()))

    init(classId: String, shopId: String) {
        super.init()
        self.classId = classId
        self.shopId  = shopId
        
        reloadSubject
            .subscribe(onNext: { [weak self] _ in  self?.requestData() })
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
}
