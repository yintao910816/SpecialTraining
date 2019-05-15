//
//  NoticesViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/15.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class NoticesViewModel: BaseViewModel {
    public let listDatasource = Variable([AddFriendsModel]())
    /// 同意添加
    public let agreeSubject = PublishSubject<AddFriendsModel>()
    /// 拒绝
    public let refuseSubject = PublishSubject<AddFriendsModel>()

    override init() {
        super.init()
        
        reloadSubject
            .subscribe(onNext: { [unowned self] in self.selectedDatas() })
            .disposed(by: disposeBag)
        
        agreeSubject
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [weak self] model in
                guard let strongSelf = self else { return }
                EMClient.shared()?.contactManager.approveFriendRequest(fromUser: model.fromUser, completion: { (msg, error) in
                    if let aerror = error {
                        strongSelf.hud.failureHidden(aerror.errorDescription)
                    }else {
                        let tempDatas = strongSelf.listDatasource.value.filter{ $0.fromUser != model.fromUser }
                        strongSelf.listDatasource.value = tempDatas
                        strongSelf.hud.successHidden("添加成功")
                        
                        AddFriendsModel.delete(with: model.fromUser)
                    }
                })
            })
            .disposed(by: disposeBag)
        
        refuseSubject
            .subscribe(onNext: { [weak self] model in
                guard let strongSelf = self else { return }
                EMClient.shared()?.contactManager.declineFriendRequest(fromUser: model.fromUser, completion: { (msg, error) in
                    if let aerror = error {
                        strongSelf.hud.failureHidden(aerror.errorDescription)
                    }else {
                        let tempDatas = strongSelf.listDatasource.value.filter{ $0.fromUser != model.fromUser }
                        strongSelf.listDatasource.value = tempDatas
                        strongSelf.hud.successHidden("添加成功")
                        
                        AddFriendsModel.delete(with: model.fromUser)
                    }
                })
            })
            .disposed(by: disposeBag)
    }
    
    private func selectedDatas() {
        AddFriendsModel.slectedApplys()
            .subscribe(onNext: { [weak self] datas in
                self?.listDatasource.value = datas
            })
            .disposed(by: disposeBag)
    }
}
