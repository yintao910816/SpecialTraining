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
    @IBOutlet weak var wchatLoginBg: UIView!
    
    @IBOutlet weak var loginOutlet: UIButton!
    @IBOutlet weak var phoneOutlet: UITextField!
    @IBOutlet weak var codeOutlet: UITextField!
    @IBOutlet weak var wchatOutlet: UIButton!
    
    @IBOutlet weak var authorOutlet: UIButton!
    
    private var viewModel: LoginViewModel!
    
    private let timer = CountdownTimer.init()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        wchatLoginBg.isHidden = !WXApi.isWXAppInstalled()
        
        #if DEBUG
        phoneOutlet.text = "18627844751"
        codeOutlet.text = "8888"
        #endif
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
        
        let loginTapDriver = loginOutlet.rx.tap.asDriver()
            .do(onNext: { [unowned self] in self.view.endEditing(true) })

        viewModel = LoginViewModel.init(input: (account: phoneOutlet.rx.text.orEmpty.asDriver(),
                                                code: codeOutlet.rx.text.orEmpty.asDriver()),
                                        tap: (loginTap: loginTapDriver,
                                              sendCodeTap: authorOutlet.rx.tap.asDriver(),
                                              wechatTap: wchatOutlet.rx.tap.asDriver()))
        
        viewModel.sendCodeSubject.subscribe(onNext: { [unowned self] (success) in
            success == true ? self.timer.timerStar() : self.timer.timerPause()
        }).disposed(by: disposeBag)
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel.bindPhoneSubject
            .subscribe(onNext: { [weak self] op_openid in
                self?.performSegue(withIdentifier: "bindPhoneSegue", sender: op_openid)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let frame = CGRect.init(x: 0, y: 0, width: loginOutlet.width, height: loginOutlet.height)
        loginOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
    }
}
