//
//  STUserVideosViewController.swift
//  SpecialTraining
//
//  Created by sw on 03/12/2018.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STUserVideosViewController: BaseViewController {

    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var bgHeader: UIView!

    @IBOutlet weak var topViewHeightCns: NSLayoutConstraint!
    @IBOutlet weak var topSaveAreaCns: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func setupUI() {
        if UIDevice.current.isX == true {
            topViewHeightCns.constant = 130 + 44
            topSaveAreaCns.constant = 20 + 44
        }else {
            topViewHeightCns.constant = 130
            topSaveAreaCns.constant = 20
        }
        
        let frame = CGRect.init(x: 0, y: 0, width: PPScreenW, height: topViewHeightCns.constant)
        bgHeader.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
    }
    
    override func rxBind() {
        
    }

}
