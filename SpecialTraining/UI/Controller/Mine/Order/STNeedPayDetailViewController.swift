//
//  STNeedPayDetailViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/2/24.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STNeedPayDetailViewController: BaseViewController {

    @IBOutlet weak var canclePayOutlet: UIButton!
    @IBOutlet weak var payOutlet: UIButton!

    override func setupUI() {
        payOutlet.layer.cornerRadius = 4.0
        payOutlet.layer.borderWidth  = 1
        payOutlet.layer.borderColor  = RGB(212, 108, 52).cgColor
        
        canclePayOutlet.layer.cornerRadius = 4.0
        canclePayOutlet.layer.borderWidth  = 1
        canclePayOutlet.layer.borderColor  = RGB(60, 60, 60).cgColor
    }
    
    override func rxBind() {
        
    }
}
