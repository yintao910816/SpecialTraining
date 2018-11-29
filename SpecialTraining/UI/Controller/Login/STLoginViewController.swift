//
//  STLoginViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/20.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STLoginViewController: BaseViewController {

    @IBOutlet weak var accountOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var loginOutlet: UIButton!
    
    private var viewModel: LoginViewModel!
    
    override func setupUI() {
        
    }
    
    override func rxBind() {
        viewModel = LoginViewModel.init(input: (account: accountOutlet.rx.text.orEmpty.asDriver(),
                                                passwd: passwordOutlet.rx.text.orEmpty.asDriver()),
                                        tap: loginOutlet.rx.tap.asDriver())
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
