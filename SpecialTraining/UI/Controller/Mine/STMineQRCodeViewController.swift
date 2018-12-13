//
//  STMineQRCodeViewController.swift
//  SpecialTraining
//
//  Created by xujun on 2018/12/13.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STMineQRCodeViewController: BaseViewController {

    @IBOutlet weak var ivQRCode: UIImageView!
    @IBOutlet weak var ivHead: UIImageView!
    
    override func setupUI() {
        title = "我的二维码"
    }
    
    override func rxBind() {
        
    }
    
    @IBAction func longPressAction(_ sender: UILongPressGestureRecognizer) {
        PrintLog("长按图片")
    }
    
}
