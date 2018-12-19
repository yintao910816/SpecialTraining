//
//  STResetPassTwoViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/12.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STResetPassTwoViewController: BaseViewController {
    
    @IBOutlet weak var verifyOutlet: UIButton!
    @IBOutlet weak var authorOutlet: UIButton!
    @IBOutlet weak var codeOutlet: UITextField!
    
    @IBAction func actions(_ sender: UIButton) {
    performSegue(withIdentifier: "setNewPassSegue", sender: nil)
    }
    
    override func setupUI() {
        
        authorOutlet.layer.cornerRadius = 2
        authorOutlet.layer.borderColor = RGB(180, 180, 180).cgColor
        authorOutlet.layer.borderWidth = 1
        
        let frame = CGRect.init(x: 0, y: 0, width: verifyOutlet.width, height: verifyOutlet.height)
        verifyOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
        
    }
    
    override func rxBind() {
        
    }
    
}
