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
    @IBOutlet weak var ivHead: UIImageView!
    
    override func setupUI() {
        title = "我的二维码"
    }
    
    override func rxBind() {
        
    }
    
    @IBAction func longPressAction(_ sender: UILongPressGestureRecognizer) {
        PrintLog("长按图片")
        if (sender.state == UIGestureRecognizer.State.began) {
            //1.初始化扫描仪，设置识别类型和识别质量
            let options = ["IDetectorAccuracy":CIDetectorAccuracyHigh]
            let detector:CIDetector = CIDetector(ofType: "CIDetectorTypeQRCode", context: nil, options: options)!
            //2.扫描获取的特征组
            let features = detector.features(in: CIImage(cgImage: (self.ivQRCode.image?.cgImage)!))
            //3.获取扫描结果
            if features.count > 0 {
                let feature = features[0] as! CIQRCodeFeature
                let scanResult = feature.messageString
                PrintLog(scanResult)
            }
        }
    }
    
}
