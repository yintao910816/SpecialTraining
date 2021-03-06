//
//  STNeedForClassViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/2/24.
//  Copyright © 2019 youpeixun. All rights reserved.
//  待上课详情

import UIKit

class STNeedForClassViewController: BaseViewController {

    @IBOutlet weak var okOutlet: UIButton!
    @IBOutlet weak var payBackOutlet: UIButton!
    
    override func setupUI() {
        payBackOutlet.layer.cornerRadius = 4.0
        payBackOutlet.layer.borderWidth  = 1
        payBackOutlet.layer.borderColor  = RGB(212, 108, 52).cgColor
        
        okOutlet.layer.cornerRadius = 4.0
        okOutlet.layer.borderWidth  = 1
        okOutlet.layer.borderColor  = RGB(212, 108, 52).cgColor
    }

}
