//
//  MineAddAccountViewModel.swift
//  SpecialTraining
//
//  Created by xujun on 2018/12/21.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MineAddAccountViewModel: BaseViewModel {
    
    var datasources = Variable([SectionModel<Int,MineAddAccountModel>]())
    
    override init() {
        datasources.value = [SectionModel.init(model: 0, items: [MineAddAccountModel(),
                                                                 MineAddAccountModel(),
                                                                 MineAddAccountModel(),
                                                                 MineAddAccountModel(),
                                                                 MineAddAccountModel()]),
                             SectionModel.init(model: 1, items: [MineAddAccountModel()])] 
    }
    
}
