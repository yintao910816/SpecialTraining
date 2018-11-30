//
//  MineCustomViewModel.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/11/30.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift

class MineCustomViewModel: BaseViewModel {
    
    var datasource = Variable([SectionModel<Int, String>]())
    
    private let sectionTitles = ["身材管理", "猎头", "我的喜好", "文化成绩"]
    
    override init() {
        super.init()
        
        datasource.value = [SectionModel.init(model: 0, items: ["身高",
                                                                "体重",
                                                                "三围",
                                                                "鞋码"]),
                            SectionModel.init(model: 1, items: ["意向(0)",
                                                                "选择(0)",
                                                                "多媒体证书",
                                                                "综合档案"]),
                            SectionModel.init(model: 2, items: ["游泳",
                                                                "文学",
                                                                "篮球",
                                                                "电脑"]),
                            SectionModel.init(model: 3, items: ["语文",
                                                                "数学",
                                                                "英语"])]
    }
    
    func sectionTitle(_ indexPath: IndexPath) ->String{
        return sectionTitles[indexPath.section]
    }
    
}
