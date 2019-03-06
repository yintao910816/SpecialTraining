//
//  MineAccountViewModel.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/3.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class MineAccountViewModel: RefreshVM<MineAccountModel>   {
    
    override init() {
        super.init()
    
        datasource.value = [MineAccountModel(), MineAccountModel(), MineAccountModel()]
    }
}
