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
    
    override func setupUI() {
        let frame = CGRect.init(x: 0, y: 0, width: okOutlet.width, height: okOutlet.height)
        okOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
    }
    
    override func rxBind() {
        
    }
    
}
