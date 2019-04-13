//
//  FeedbackViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/4/14.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FeedbackViewModel: BaseViewModel {
    
    init(input:(fackBackContent: Driver<String>, phone: Driver<String>),
        submit: Driver<Void>) {
        super.init()
        
        let signal = Driver.combineLatest(input.fackBackContent, input.phone){ ($0, $1) }
        submit.withLatestFrom(signal)
            .filter{ [unowned self] in self.judgeContent(fackBackContent: $0.0, phone: $0.1) }
            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] data in
                self.faceBackRequest(category_id: "1", content: data.0, contact: data.1)
            })
            .disposed(by: disposeBag)
    }
    
    private func faceBackRequest(category_id: String, content: String, contact: String) {
        STProvider.request(.feedback(category_id: category_id, content: content, contact: contact, member_id: "1"))
            .map(model: SingleResponseModel.self)
            .subscribe(onSuccess: { [weak self] resModel in
                if resModel.errno == 0 {
                    self?.hud.successHidden(resModel.data, {
                        self?.popSubject.onNext(Void())
                    })
                }else {
                    self?.hud.failureHidden(resModel.errmsg)
                }
            }) { [weak self] (error) in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
    private func judgeContent(fackBackContent: String, phone: String) ->Bool{
        if fackBackContent.count == 0 {
            hud.failureHidden("请输入反馈内容")
            return false
        }
        
        if ValidateNum.phoneNum(phone).isRight == false {
            hud.failureHidden("请输入正确的手机号")
            return false
        }
        
        return true
    }
}
