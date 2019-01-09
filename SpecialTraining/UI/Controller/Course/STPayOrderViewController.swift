//
//  STPayOrderViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/1/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STPayOrderViewController: BaseViewController {

    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet var wchatPayTapGes: UITapGestureRecognizer!
    @IBOutlet var zfbPayTapGes: UITapGestureRecognizer!

    @IBOutlet weak var wchatChoseOutlet: UIButton!
    @IBOutlet weak var zfbChoseOutlet: UIButton!
    @IBOutlet weak var okOutlet: UIButton!
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        if sender == wchatPayTapGes {
            wchatChoseOutlet.isHidden = false
            zfbChoseOutlet.isHidden = true
        }else {
            wchatChoseOutlet.isHidden = true
            zfbChoseOutlet.isHidden = false
        }
    }
    
}
