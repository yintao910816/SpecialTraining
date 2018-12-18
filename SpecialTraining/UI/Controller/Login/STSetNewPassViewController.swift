//
//  STSetNewPassViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/13.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STSetNewPassViewController: BaseViewController {

    @IBOutlet weak var okOutlet: UIButton!
    @IBOutlet weak var passOutlet: UITextField!
    
    private var viewModel: SetNewPwdViewModel!
    
    override func setupUI() {
        let frame = CGRect.init(x: 0, y: 0, width: okOutlet.width, height: okOutlet.height)
        okOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
    }
    
    override func rxBind() {
        
    }
    
    override func prepare(parameters: [String : Any]?) {
        let phone = parameters!["phone"] as! String
        let code = parameters!["code"] as! String
        
        viewModel = SetNewPwdViewModel(tap: okOutlet.rx.tap.asDriver(), pwd: passOutlet.rx.text.orEmpty.asDriver(), code: code, phone: phone)
    }
    
}
