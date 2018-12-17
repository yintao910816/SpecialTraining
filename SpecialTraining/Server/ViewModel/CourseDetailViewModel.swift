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
    
    let splendidnessContentSource = Variable([String]())
    let courseTimeSource = Variable([SectionModel<Int, String>]())

    override init() {
        super.init()
        
        splendidnessContentSource.value = ["1", "2", "3", "4", "5", "6", "7"]
        courseTimeSource.value = [SectionModel.init(model: 0, items: ["1", "2", "3", "4"]),
                                  SectionModel.init(model: 1, items: ["1", "2", "3", "4"])]
    }
}
