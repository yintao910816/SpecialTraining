//
//  ExpericeCourseDetailViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/11.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class ExpericeCourseDetailViewModel: BaseViewModel {
    private var courseId: String = ""
    
    let courseInfoObser = Variable(CourseDetailModel())
    
    init(courseId: String) {
        super.init()
        
        self.courseId = courseId
        
        reloadSubject
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [weak self] in
                self?.requestData()
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
}
