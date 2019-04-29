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
    
    private let sectionTitles = ["成为机构", "吐槽"]
    
    override init() {
        super.init()
        
        datasource.value = [SectionModel.init(model: 0, items: [MineModel.creatModel(title: "全部",
                                                                                     imageString: "mine_daifukuan",
                                                                                     segueIdentifier:"myOrderSegue",
                                                                                     clickedOrderIdx: 0),
                                                                MineModel.creatModel(title: "待付款",
                                                                                     imageString: "mine_daipaike",
                                                                                     segueIdentifier:"myOrderSegue",
                                                                                     clickedOrderIdx: 1),
                                                                MineModel.creatModel(title: "已付款",
                                                                                     imageString: "mine_daishangke",
                                                                                     segueIdentifier:"myOrderSegue",
                                                                                     clickedOrderIdx: 2),
                                                                MineModel.creatModel(title: "退款",
                                                                                     imageString: "mine_tuikuan",
                                                                                     segueIdentifier:"myOrderSegue",
                                                                                     clickedOrderIdx: 3)]),
//                            SectionModel.init(model: 1, items: [MineModel.creatModel(title: "文章",
//                                                                                     imageString: "mine_shoucangwenzhang",
//                                                                                     segueIdentifier: "collectionSegue"),
//                                                                MineModel.creatModel(title: "图片相册",
//                                                                                     imageString: "mine_shoucangtupian",
//                                                                                     segueIdentifier: "collectionSegue"),
//                                                                MineModel.creatModel(title: "视屏",
//                                                                                     imageString: "mine_shoucangshiping",
//                                                                                     segueIdentifier: "collectionSegue"),
//                                                                MineModel.creatModel(title: "音频",
//                                                                                     imageString: "mine_shucangyinping",
//                                                                                     segueIdentifier: "collectionSegue")]),
                            SectionModel.init(model: 2, items: [MineModel.creatModel(title: "机构入驻",
                                                                                     imageString: "mine_jigoukaidian",
                                                                                     segueIdentifier: "registerOrganizationSegue"),
//                                                                MineModel.creatModel(title: "宝贝互换",
//                                                                                     imageString: "mine_baobeihuhuan",
//                                                                                     segueIdentifier: "treasureExchangeSegue"),
//                                                                MineModel.creatModel(title: "商品买卖", imageString: "mine_wodeshangpingmaimai")
                                ]),
//                            SectionModel.init(model: 3, items: [MineModel.creatModel(title: "备课",
//                                                                                     imageString: "mine_laoshibeike",
//                                                                                     segueIdentifier: "teacherPrepareSegue"),
//                                                                MineModel.creatModel(title: "排课表", imageString: "mine_laoshikechengbiao")]),
                            SectionModel.init(model: 3, items: [MineModel.creatModel(title: "优学乐秀",
                                                                                     imageString: "mine_tousuliuyan",
                                                                                     segueIdentifier: "faceBackSegue")])
        ]
    }
    
    func sectionTitle(_ indexPath: IndexPath) ->String{
        return sectionTitles[indexPath.section - 1]
    }
}
