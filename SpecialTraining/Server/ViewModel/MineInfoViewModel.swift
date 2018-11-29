//
//  MineInfoViewModel.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/19.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift

class MineInfoViewModel: BaseViewModel {
    
    let datasource = Variable([SectionModel<Int, MineInfoModelAdapt>]())
    
    override init() {
        super.init()
        
        datasource.value = [SectionModel.init(model: 0, items: [MineInfoModel.creatModel(title: "头像", detailImageStr: ""),
                                                                MineInfoModel.creatModel(title: "昵称", detailTitle: "张小二"),
                                                                MineInfoModel.creatModel(title: "平台账号", detailTitle: "18627875"),
                                                                MineInfoModel.creatModel(title: "我的二维码", detailImageStr: ""),
                                                                MineInfoModel.creatModel(title: "地址"),
                                                                MineInfoModel.creatModel(title: "手机号码"),
                                                                MineInfoModel.creatModel(title: "身份证号"),
                                                                MineInfoModel.creatModel(title: "我的推荐人")]),
                            SectionModel.init(model: 1, items: [MineInfoModel.creatModel(title: "我的定制")]),
                            SectionModel.init(model: 2, items: [StudentInfoModel()])]
    }
}
