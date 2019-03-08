//
//  WithdrawViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation

class WithdrawViewModel: RefreshVM<MineAccountModel>   {
    
    override init() {
        super.init()
        
        datasource.value = [MineAccountModel(), MineAccountModel(), MineAccountModel()]
    }
}
