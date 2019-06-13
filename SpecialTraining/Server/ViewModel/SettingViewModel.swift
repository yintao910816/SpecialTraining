//
//  SettingViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/1.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class SettingViewModel: BaseViewModel, VMNavigation {
    
    var datasource = Variable([SectionModel<Int, String>]())
    let cellDidSelected = PublishSubject<String>()
    
    let pushNoticeSettingSubject = PublishSubject<Void>()
    let pushUseTipsSubject = PublishSubject<Void>()

    override init() {
        super.init()
        
        reloadSubject.subscribe(onNext: { [weak self] in
            self?.datasource.value = [SectionModel.init(model: 0, items: ["新消息通知", "使用技巧"]),
                                      SectionModel.init(model: 1, items: ["退出登录"])]
        })
        .disposed(by: disposeBag)
        
        cellDidSelected
            .subscribe(onNext: { [unowned self] in self.pushDetail(title: $0) })
            .disposed(by: disposeBag)
    }
    
    private func pushDetail(title: String) {
        if title == "退出登录" {
            STHelper.presentLogin()
        }else if title == "新消息通知" {
            NoticesCenter.alert(message: "敬请期待...")
//            pushNoticeSettingSubject.onNext(Void())
        }else if title == "使用技巧" {
//            pushUseTipsSubject.onNext(Void())
            NoticesCenter.alert(message: "敬请期待...")
        }
    }
}
