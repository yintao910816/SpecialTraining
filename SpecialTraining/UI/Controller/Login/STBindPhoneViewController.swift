//
//  STBindPhoneViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/13.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STBindPhoneViewController: BaseViewController {

    @IBOutlet weak var phoneOutlet: UITextField!
    @IBOutlet weak var codeOutlet: UITextField!
    @IBOutlet weak var okOutlet: UIButton!
    @IBOutlet weak var authorOutlet: UIButton!
    
    private var op_openid: String?
    
    private var viewModel: BindPhoneViewModel!
    
    private let timer = CountdownTimer.init()
    
    override func setupUI() {
        let frame = CGRect.init(x: 0, y: 0, width: okOutlet.width, height: okOutlet.height)
        okOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
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
        
        viewModel = BindPhoneViewModel(phone: phoneOutlet.rx.text.orEmpty.asDriver(), code: codeOutlet.rx.text.orEmpty.asDriver(), sendAuth: authorOutlet.rx.tap.asDriver(), next: okOutlet.rx.tap.asDriver(), op_openid: op_openid ?? "")
        
        viewModel.sendCodeSubject.subscribe(onNext: { [unowned self] (success) in
            success == true ? self.timer.timerStar() : self.timer.timerPause()
        }).disposed(by: disposeBag)
    }
    
    override func prepare(parameters: [String : Any]?) {
        op_openid = parameters!["op_openid"] as? String
    }
    
}
