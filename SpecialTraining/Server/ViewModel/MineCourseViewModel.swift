//
//  MineCourseViewModel.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/3.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class MineCourseViewModel: RefreshVM<MineCourseModel> {
    override init() {
        super.init()
        
        self.datasource.value = [MineCourseModel(),MineCourseModel(),MineCourseModel(),MineCourseModel(),MineCourseModel()]
    }
}
