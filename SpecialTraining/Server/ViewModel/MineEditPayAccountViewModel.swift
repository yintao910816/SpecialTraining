//
//  MineEditPayAccountViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift

class MineEditPayAccountViewModel: BaseViewModel {
    
    let datasource = Variable([SectionModel<Int, String>]())
    
    override init() {
        super.init()
        
        datasource.value = [SectionModel.init(model: 0, items: ["", "", ""])]
    }
}


