//
//  STMineQRCodeViewController.swift
//  SpecialTraining
//
//  Created by xujun on 2018/12/13.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class STMineQRCodeViewController: BaseViewController {

    @IBOutlet weak var ivQRCode: UIImageView!
    
    override func setupUI() {

    }
    
    override func rxBind() {
        
    }
    
    @IBAction func longPressAction(_ sender: UILongPressGestureRecognizer) {
        NoticesCenter.alertActionSheet(actionTitles: ["保存"], cancleTitle: "取消",presentCtrl: self) { idx in
            PrintLog(idx)
        }
    }
    
}
