//
//  MineChangeViewModel.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/3.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit
import RxSwift

class MineChangeViewModel: RefreshVM<MineChangeModel> {
        
    override init() {
        super.init()
        
        self.datasource.value = [MineChangeModel(),MineChangeModel(),MineChangeModel(),MineChangeModel(),MineChangeModel()]
    }
}
