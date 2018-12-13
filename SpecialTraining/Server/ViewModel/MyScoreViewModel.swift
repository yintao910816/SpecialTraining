//
//  MyScoreViewModel.swift
//  SpecialTraining
//
//  Created by sw on 13/12/2018.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class MyScoreViewModel: BaseViewModel {
    
      let datasource = Variable([String]())
    
    override init() {
        super.init()
        
        datasource.value = ["1", "2", "3", "4", "2", "3", "4", "2", "3", "4"]
    }
}
