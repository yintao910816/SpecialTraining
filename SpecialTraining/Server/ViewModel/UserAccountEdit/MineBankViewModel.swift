//
//  MineBankViewModel.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/4.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit
import RxSwift

class MineBankViewModel: BaseViewModel {
    
    var datasource = Variable([MineBankModel]())
    
    override init() {
        super.init()
        
        datasource.value = [MineBankModel(),MineBankModel(),MineBankModel(),MineBankModel(),MineBankModel()]
    }
    
}
