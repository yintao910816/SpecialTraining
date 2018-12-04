//
//  STVideoDemandViewController.swift
//  SpecialTraining
//
//  Created by sw on 03/12/2018.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STVideoDemandViewController: BaseViewController {

    @IBOutlet weak var navHeightCns: NSLayoutConstraint!
    @IBOutlet weak var navtTopCns: NSLayoutConstraint!
    
    @IBAction func actions(_ sender: UIButton) {
        switch sender.tag {
        case 200:
            navigationController?.popViewController(animated: true)
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        if UIDevice.current.isX {
            navHeightCns.constant += 44
            navtTopCns.constant    = 22
        }else {
            navHeightCns.constant = 50
            navtTopCns.constant   = 0
        }
    }
    
    override func rxBind() {
        
    }
}
