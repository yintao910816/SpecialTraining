//
//  MyClassViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/15.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class MyClassViewModel: BaseViewModel {
    
    let listDataSource = Variable([MyClassModel]())
    
    override init() {
        super.init()
        reloadSubject
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] in
                self.requestData()
            })
            .disposed(by: disposeBag)
    }
    
    private func requestData() {
        STProvider.request(.myClass())
            .map(models: MyClassModel.self)
            .subscribe(onSuccess: { [weak self] data in
                for idx in 0..<data.count { data[idx].levelString = "\(idx)" }
                self?.listDataSource.value = data
                self?.hud.noticeHidden()
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
}
