//
//  MineCollectionViewModel.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/7.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MineCollectionViewModel: BaseViewModel {
    
    let tableDatasource = Variable([MineCollectionModel]())
    
    let colDatasource = Variable([MineCollectionHeaderModel]())
    let colSubject = PublishSubject<MineCollectionHeaderModel>()
    
    override init() {
        super.init()
        
        tableDatasource.value = [MineCollectionModel(),MineCollectionModel(),MineCollectionModel(),MineCollectionModel(),MineCollectionModel()]
        
        colDatasource.value = [MineCollectionHeaderModel.createModel(title: "图片与视频"),
                               MineCollectionHeaderModel.createModel(title: "链接"),
                               MineCollectionHeaderModel.createModel(title: "文件"),
                               MineCollectionHeaderModel.createModel(title: "音乐"),
                               MineCollectionHeaderModel.createModel(title: "聊天记录"),
                               MineCollectionHeaderModel.createModel(title: "语音"),
                               MineCollectionHeaderModel.createModel(title: "笔记"),
                               MineCollectionHeaderModel.createModel(title: "位置")]
        
        colSubject.subscribe(onNext: { [unowned self] (model) in
            let tempData = self.colDatasource.value
            self.colDatasource.value = tempData.map({ d -> MineCollectionHeaderModel in
                d.isSelected = d.title == model.title ? true : false
                return d
            })
        }).disposed(by: disposeBag)
    }
}


