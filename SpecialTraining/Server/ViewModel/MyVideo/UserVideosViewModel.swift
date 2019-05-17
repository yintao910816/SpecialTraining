//
//  UserVideosViewModel.swift
//  SpecialTraining
//
//  Created by sw on 04/12/2018.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class UserVideosViewModel: BaseViewModel {
    
    var userVidesDatasource = Variable([MyVidesModel]())
    var videosCountObser = Variable("作品0")
    
    override init() {
        super.init()

        reloadSubject
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [weak self] _ in
                self?.requestVideData()
            })
            .disposed(by: disposeBag)
    }
    
    private func requestVideData() {
        STProvider.request(.myVideo())
            .map(models: MyVidesModel.self)
            .subscribe(onSuccess: { [weak self] datas in
                self?.hud.noticeHidden()
                self?.userVidesDatasource.value = datas
                self?.videosCountObser.value = "\(datas.count)"
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
}
