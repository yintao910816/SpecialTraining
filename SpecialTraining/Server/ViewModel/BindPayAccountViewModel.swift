//
//  BindPayAccountViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/10.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift

class BindPayAccountViewModel: BaseViewModel {
    
    let datasource = Variable([MineEditPayAccountModel]())
    
    override init() {
        super.init()
        
        datasource.value = MineEditPayAccountModel.creatModel()
    }
}

class MineEditPayAccountModel {
    var title: String = ""
    var icon: UIImage?
    
    class func creatModel() ->[MineEditPayAccountModel]{
        let m = MineEditPayAccountModel()
        m.title = "＋支付宝账户"
        m.icon  = UIImage.init(named: "demandView_bg")
        
        let m1 = MineEditPayAccountModel()
        m1.title = "＋微信账户"
        m1.icon = UIImage.init(named: "wchat_login")
        
        return [m, m1]
    }
}
