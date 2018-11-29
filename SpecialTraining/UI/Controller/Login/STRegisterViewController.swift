//
//  STRegisterViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/20.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STRegisterViewController: BaseViewController {

    @IBOutlet weak var nickeNameOutlet: UITextField!
    @IBOutlet weak var accountOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!

    @IBOutlet weak var submitOutlet: UIButton!
    
    var viewModel: RegisterViewModel!
    
    override func setupUI() {
        
    }
    
    override func rxBind() {
        viewModel = RegisterViewModel.init(input: (account: accountOutlet.rx.text.orEmpty.asDriver(),
                                                   passwd: passwordOutlet.rx.text.orEmpty.asDriver(),
                                                   nickName: nickeNameOutlet.rx.text.orEmpty.asDriver()),
                                           tap: submitOutlet.rx.tap.asDriver())
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
}
