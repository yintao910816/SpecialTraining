//
//  ResetPasOneViewModel.swift
//  SpecialTraining
//
//  Created by xujun on 2018/12/18.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ResetPasOneViewModel: BaseViewModel,VMNavigation {
    
    init(phone: Driver<String>, next: Driver<Void>) {
        
        super.init()
        
        next.withLatestFrom(phone)
            .filter { [unowned self] (phone) -> Bool in
                if ValidateNum.phoneNum(phone).isRight == false {
                    self.hud.failureHidden("请输入正确的手机号")
                    return false
                }
                return true
        }.asDriver()
            .drive(onNext: { (phone) in
                ResetPasOneViewModel.sbPush("STLogin", "resettwo", bundle: Bundle.main, parameters: ["phone":phone])
            }).disposed(by: disposeBag)
        
    }
    
}
