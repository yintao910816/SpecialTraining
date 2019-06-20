//
//  STResetPassOneViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/12.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STResetPassOneViewController: BaseViewController {

    @IBOutlet weak var nextOutlet: UIButton!
    @IBOutlet weak var phoneTF: UITextField!
    
    private var viewModel: ResetPasOneViewModel!
    
    override func setupUI() {
        
    }
    
    override func rxBind() {
        
        viewModel = ResetPasOneViewModel(phone: phoneTF.rx.text.orEmpty.asDriver(), next: nextOutlet.rx.tap.asDriver())

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let frame = CGRect.init(x: 0, y: 0, width: nextOutlet.width, height: nextOutlet.height)
        nextOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
    }

}
