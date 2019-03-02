//
//  MyAddressViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/3.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class MyAddressViewModel: BaseViewModel {
    
    let datasource = Variable([MyAddressModel]())

    override init() {
        super.init()
        
        datasource.value = MyAddressModel.testData()
    }
}

class EditMyAddressViewModel: BaseViewModel {
    
    let datasource = Variable([MyAddressModel]())
    
    override init() {
        super.init()
        
        datasource.value = MyAddressModel.testEditAddressModel()
    }
}
