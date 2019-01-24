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
    
    private var phone: String?
    private var code: String?
    
    private var viewModel: SetNewPwdViewModel!
    
    override func setupUI() {
        let frame = CGRect.init(x: 0, y: 0, width: okOutlet.width, height: okOutlet.height)
        okOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
    }
    
    override func rxBind() {
        let okDriver = okOutlet.rx.tap.asDriver()
            .do(onNext: { [unowned self] in self.view.endEditing(true) })

        viewModel = SetNewPwdViewModel(tap: okDriver,
                                       pwd: passOutlet.rx.text.orEmpty.asDriver(),
                                       code: code ?? "",
                                       phone: phone ?? "")
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    override func prepare(parameters: [String : Any]?) {
        phone = parameters!["phone"] as? String
        code = parameters!["code"] as? String
    }
    
}
