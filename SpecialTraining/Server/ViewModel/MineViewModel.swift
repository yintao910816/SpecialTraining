//
//  MineViewModel.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/18.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class MineViewModel: BaseViewModel {
    
    var datasource = Variable([SectionModel<Int, MineModel>]())
    
    private let sectionTitles = ["收藏", "我要开店", "老师备课", "投诉留言"]
    
    override init() {
        super.init()
        
        datasource.value = [SectionModel.init(model: 0, items: [MineModel.creatModel(title: "待付款", imageString: "mine_daifukuan"),
                                                                MineModel.creatModel(title: "待排课/发货", imageString: "mine_daipaike"),
                                                                MineModel.creatModel(title: "待上课/收货", imageString: "mine_daishangke"),
                                                                MineModel.creatModel(title: "待评价", imageString: "mine_daipingjia"),
                                                                MineModel.creatModel(title: "退款/售后", imageString: "mine_tuikuan")]),
                            SectionModel.init(model: 1, items: [MineModel.creatModel(title: "文章", imageString: "mine_shoucangwenzhang"),
                                                                MineModel.creatModel(title: "图片相册", imageString: "mine_shoucangtupian"),
                                                                MineModel.creatModel(title: "视屏", imageString: "mine_shoucangshiping"),
                                                                MineModel.creatModel(title: "音频", imageString: "mine_shucangyinping")]),
                            SectionModel.init(model: 2, items: [MineModel.creatModel(title: "成为机构", imageString: "mine_jigoukaidian"),
                                                                MineModel.creatModel(title: "宝贝互换",
                                                                                     imageString: "mine_baobeihuhuan",
                                                                                     segueIdentifier: "treasureExchangeSegue"),
                                                                MineModel.creatModel(title: "商品买卖", imageString: "mine_wodeshangpingmaimai")]),
                            SectionModel.init(model: 3, items: [MineModel.creatModel(title: "备课",
                                                                                     imageString: "mine_laoshibeike",
                                                                                     segueIdentifier: "teacherPrepareSegue"),
                                                                MineModel.creatModel(title: "排课表", imageString: "mine_laoshikechengbiao")]),
                            SectionModel.init(model: 4, items: [MineModel.creatModel(title: "投诉", imageString: "mine_tousuliuyan")])]
    }
    
    func sectionTitle(_ indexPath: IndexPath) ->String{
        return sectionTitles[indexPath.section - 1]
    }
}
