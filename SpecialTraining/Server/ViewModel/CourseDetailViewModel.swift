//
//  CourseDetailViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2018/12/14.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class CourseDetailViewModel: BaseViewModel {
    
    let splendidnessContentSource = Variable([String]())
    
    override init() {
        super.init()
        
        splendidnessContentSource.value = ["1", "2", "3", "4", "5", "6", "7"]
    }
}
