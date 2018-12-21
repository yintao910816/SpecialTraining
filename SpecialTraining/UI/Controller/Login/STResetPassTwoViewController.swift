//
//  STResetPassTwoViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/12.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STResetPassTwoViewController: BaseViewController {
    
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var verifyOutlet: UIButton!
    @IBOutlet weak var authorOutlet: UIButton!
    @IBOutlet weak var codeOutlet: UITextField!
    private var phone: String?
    
    private var viewModel: SendMessageViewModel!
    
    private let timer = CountdownTimer.init()
    
    override func setupUI() {
        
        authorOutlet.layer.cornerRadius = 2
        authorOutlet.layer.borderColor = RGB(180, 180, 180).cgColor
        authorOutlet.layer.borderWidth = 1
        
        let frame = CGRect.init(x: 0, y: 0, width: verifyOutlet.width, height: verifyOutlet.height)
        verifyOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
        
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
        
        viewModel = SendMessageViewModel.init(tap: authorOutlet.rx.tap.asDriver(), authCode: codeOutlet.rx.text.orEmpty.asDriver(), next: verifyOutlet.rx.tap.asDriver(), phone: phone ?? "")
        phoneLbl.text = phone?.replacePhone()
        
        viewModel.sendCodeSubject.subscribe(onNext: { [unowned self] (success) in
            success == true ? self.timer.timerStar() : self.timer.timerPause()
        }).disposed(by: disposeBag)
    }
    
    override func prepare(parameters: [String : Any]?) {
        phone = parameters!["phone"] as? String
    }
    
}
