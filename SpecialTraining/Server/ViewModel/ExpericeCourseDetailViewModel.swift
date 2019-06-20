//
//  ExpericeCourseDetailViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/11.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class ExpericeCourseDetailViewModel: BaseViewModel, VMNavigation {
    private var courseId: String = ""
    
    let courseInfoObser = Variable(CourseDetailModel())
    let insertShoppingCar = PublishSubject<Void>()
    let buySubject = PublishSubject<Void>()
    let gotoShopDetailSubject = PublishSubject<Void>()
    
    init(courseId: String) {
        super.init()
        
        self.courseId = courseId
        
        reloadSubject
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [weak self] in
                self?.requestData()
            })
            .disposed(by: disposeBag)
        
        insertShoppingCar
            .subscribe(onNext: { [unowned self] in
                self.insertShoppingClass(showMsg: true)
            })
            .disposed(by: disposeBag)
        
        buySubject
            .subscribe(onNext: { [unowned self] in
                self.insertShoppingClass()
                if self.courseInfoObser.value.classList.count > 0 {
                    let classIds = [self.courseInfoObser.value.classList.first!.class_id]
                    ExpericeCourseDetailViewModel.sbPush("STHome", "verifyCtrlID", parameters: ["classIds": classIds])
                }
            })
            .disposed(by: disposeBag)
        
        gotoShopDetailSubject
            .subscribe(onNext: { [unowned self] in
                ExpericeCourseDetailViewModel.sbPush("STHome", "ShopInfoSegue", parameters: ["shop_id": self.courseInfoObser.value.course_info.shop_id])
            })
            .disposed(by: disposeBag)
    }
    
    private func requestData() {
        STProvider.request(.courseDetail(id: courseId))
            .map(model: CourseDetailModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.courseInfoObser.value = data
                self?.hud.noticeHidden()
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
    private func insertShoppingClass(showMsg: Bool = false) {
        CourseDetailClassModel.inster(classInfo: courseInfoObser.value.classList, courseDetail: courseInfoObser.value.course_info)
        NotificationCenter.default.post(name: NotificationName.Order.AddOrder, object: courseInfoObser.value.classList.first)
        if showMsg { hud.successHidden("添加成功") }
    }
}
