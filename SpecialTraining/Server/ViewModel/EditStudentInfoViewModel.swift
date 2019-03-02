//
//  EditStudentInfoViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/3.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class EditStudentInfoViewModel: BaseViewModel {
    
    let datasource = Variable([SectionModel<Int, MineInfoModel>]())

    override init() {
        super.init()
        
        setupData()
    }
    
    private func setupData() {

        datasource.value = [SectionModel.init(model: 0, items: [MineInfoModel.creatModel(title: "学员照片", detailImageStr: "")]),
                            SectionModel.init(model: 1, items: [MineInfoModel.creatModel(title: "姓名", detailTitle: "未填写"),
                                                                MineInfoModel.creatModel(title: "性别", detailTitle: "未填写"),
                                                                MineInfoModel.creatModel(title: "出生日期", detailTitle: "1999年9月9日")]),
                            SectionModel.init(model: 2, items: [MineInfoModel.creatModel(title: "就读学校", detailTitle: "未填写"),
                                                                MineInfoModel.creatModel(title: "年级", detailTitle: ""),
                                                                MineInfoModel.creatModel(title: "班级", detailTitle: "")]),
                            SectionModel.init(model: 1, items: [MineInfoModel.creatModel(title: "监护人姓名", detailTitle: "未填写"),
                                                                MineInfoModel.creatModel(title: "紧急联系号码", detailTitle: "未填写")])]
    }
}
