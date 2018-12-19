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
    
    override func setupUI() {
        let frame = CGRect.init(x: 0, y: 0, width: okOutlet.width, height: okOutlet.height)
        okOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
    }
    
    override func rxBind() {
        viewModel = BindPhoneViewModel(phone: phoneOutlet.rx.text.orEmpty.asDriver(), code: codeOutlet.rx.text.orEmpty.asDriver(), sendAuth: authorOutlet.rx.tap.asDriver(), next: okOutlet.rx.tap.asDriver(), op_openid: op_openid ?? "")
    }
    
    override func prepare(parameters: [String : Any]?) {
        op_openid = parameters!["op_openid"] as? String
    }
    
}
