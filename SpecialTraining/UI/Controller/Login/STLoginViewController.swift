//
//  STLoginViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/20.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STLoginViewController: BaseViewController {

    @IBOutlet weak var contentBgView: UIView!

    @IBOutlet weak var loginOutlet: UIButton!
    @IBOutlet weak var phoneOutlet: UITextField!
    @IBOutlet weak var passOutlet: UITextField!
    @IBOutlet weak var wchatOutlet: UIButton!
    
    @IBOutlet weak var topBgHeightCns: NSLayoutConstraint!
    
    private var viewModel: LoginViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        topBgHeightCns.constant += UIDevice.current.isX ? 44 : 0
        
        let frame = CGRect.init(x: 0, y: 0, width: loginOutlet.width, height: loginOutlet.height)
        loginOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)

    }
    
    override func rxBind() {
        
        wchatOutlet.rx.tap.asDriver()
            .drive(onNext: {
                STHelper .sendWXAuth()
            })
            .disposed(by: disposeBag)
        
        viewModel = LoginViewModel.init(input: (account: phoneOutlet.rx.text.orEmpty.asDriver(),
                                                passwd: passOutlet.rx.text.orEmpty.asDriver()),
                                        tap: loginOutlet.rx.tap.asDriver())
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
