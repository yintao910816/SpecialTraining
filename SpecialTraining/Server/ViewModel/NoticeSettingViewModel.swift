//
//  NoticeSettingViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/1.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class NoticeSettingViewModel: BaseViewModel {
    
    var datasource = Variable([SectionModel<Int, NoticeSettingModel>]())
    
    let cellDidSelected = PublishSubject<IndexPath>()
    
    override init() {
        super.init()
        
        reloadSubject.subscribe(onNext: { [weak self] in
            self?.datasource.value = [SectionModel.init(model: 0, items: NoticeSettingModel.creatDatas())]
        })
            .disposed(by: disposeBag)
        
        cellDidSelected
            .subscribe(onNext: { [unowned self] in self.setNotice(indexPath: $0) })
            .disposed(by: disposeBag)
    }
    
    private func setNotice(indexPath: IndexPath) {
        var tempData = datasource.value
        let selectedTitle = tempData[indexPath.section].items[indexPath.row].title

        var sectionModel = tempData[indexPath.section].items
        sectionModel = sectionModel.map{ model -> NoticeSettingModel in
            if model.title == selectedTitle {
                model.isSelected = true
            }else {
                model.isSelected = false
            }
            return model
        }
        
        tempData[indexPath.section] = SectionModel<Int, NoticeSettingModel>.init(model: indexPath.section, items: sectionModel)
        
        datasource.value = tempData
    }
}

class NoticeSettingModel {
    
    var title: String = ""
    var isSelected: Bool = false
    
    class func creatDatas() ->[NoticeSettingModel] {
        let m1 = NoticeSettingModel()
        m1.title = "声音"
        m1.isSelected = true
        
        let m2 = NoticeSettingModel()
        m2.title = "震动"
        m2.isSelected = false

        return [m1, m2]
    }
}
