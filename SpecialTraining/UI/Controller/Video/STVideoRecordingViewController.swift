//
//  STVideoRecordingViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/8.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STVideoRecordingViewController: fileOutputViewController {

//    private var sessionManager: AVCaptureSessionManager!
    
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var recordBar: UIView!
    
    @IBAction func actions(_ sender: UIButton) {
        switch sender.tag {
        case 100:
            dismiss(animated: true, completion: nil)
        case 101:
            record()
            sender.isSelected = !sender.isSelected
            bottomBar.isHidden = !sender.isSelected
            recordBar.isHidden = sender.isSelected    
        default:
            break
        }
    }
    
    override func setupUI() {
//        sessionManager = AVCaptureSessionManager.init(root: self)
//        sessionManager.delegate = self
    }
    
    override func rxBind() {
        
    }
    
    override func didFinishRecording(coordinator: CaptureSessionCoordinator, url: URL) {
        super.didFinishRecording(coordinator: coordinator, url: url)
        
        splitVideoFileUrlFps(splitFileUrl: url, fps: 2) { (ret, images) in
            PrintLog(images.count)
        }
    }

}
