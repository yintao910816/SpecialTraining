//
//  STAuthorCodeLoginViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/13.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STAuthorCodeLoginViewController: BaseViewController {
    
    @IBOutlet weak var contentBgView: UIView!
    
    @IBOutlet weak var loginOutlet: UIButton!
    @IBOutlet weak var phoneOutlet: UITextField!
    @IBOutlet weak var codeOutlet: UITextField!
    @IBOutlet weak var wchatOutlet: UIButton!
    
    @IBOutlet weak var authorOutlet: UIButton!

    @IBOutlet weak var topBgHeightCns: NSLayoutConstraint!
    
    private var viewModel: LoginViewModel!
    
    private let timer = CountdownTimer.init()
    
    @IBAction func actions(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        topBgHeightCns.constant += UIDevice.current.isX ? 44 : 0
                
        let frame = CGRect.init(x: 0, y: 0, width: loginOutlet.width, height: loginOutlet.height)
        loginOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
        
    }
    
    override func rxBind() {
        
        timer.showText.asDriver().skip(1)
            .drive(onNext: { [unowned self] (second) in
                if second == 0 {
                    self.authorOutlet.isUserInteractionEnabled = true
                    self.authorOutlet.setTitle("获取验证码", for: .normal)
                } else {
                    self.authorOutlet.isUserInteractionEnabled = false
                    self.authorOutlet.setTitle("\(second)s", for: .normal)
                }
            }).disposed(by: disposeBag)
        
        viewModel = LoginViewModel.init(input: (account: phoneOutlet.rx.text.orEmpty.asDriver(),
                                                passwd: codeOutlet.rx.text.orEmpty.asDriver()),
                                        tap: (loginTap: loginOutlet.rx.tap.asDriver(),
                                              sendCodeTap: authorOutlet.rx.tap.asDriver(),
                                              wechatTap: wchatOutlet.rx.tap.asDriver()),
                                        loginType: "2")
        
        viewModel.sendCodeSubject.subscribe(onNext: { [unowned self] (success) in
            success == true ? self.timer.timerStar() : self.timer.timerPause()
        }).disposed(by: disposeBag)
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
