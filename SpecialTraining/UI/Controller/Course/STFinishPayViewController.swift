//
//  STFinishPayViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/1/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STFinishPayViewController: BaseViewController {

    @IBOutlet weak var headerBgView: UIView!
    @IBOutlet weak var bgHeightCns: NSLayoutConstraint!
    @IBOutlet weak var topCns: NSLayoutConstraint!
    
    override func setupUI() {
        if UIDevice.current.isX == true {
            topCns.constant = topCns.constant + 44
            bgHeightCns.constant = bgHeightCns.constant + 44
        }
        
        let frame = CGRect.init(x: 0, y: 0, width: headerBgView.width, height: bgHeightCns.constant)
        headerBgView.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
    }
    
    override func rxBind() {
        
    }
}
