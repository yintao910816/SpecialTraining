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
    
    @IBOutlet weak var nextOutlet: UIButton!
    
    private let hud = NoticesCenter()
    
    private var videoImages: [UIImage]!
    
    @IBAction func actions(_ sender: UIButton) {
        switch sender.tag {
        case 100:
            dismiss(animated: true, completion: nil)
        case 101:
            record()
            sender.isSelected = !sender.isSelected
        case 102:
            // 选择封面
            performSegue(withIdentifier: "choseCoverSegue", sender: nil)
        case 103:
            // 下一步
            performSegue(withIdentifier: "publishSegue", sender: nil)
        case 104:
            // 翻转
            break
        case 105:
            // 上传
            break
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        let frame = CGRect.init(x: 0, y: 0, width: nextOutlet.width, height: nextOutlet.height)
        nextOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
    }
    
    override func rxBind() {
        
    }
    
    override func didFinishRecording(coordinator: CaptureSessionCoordinator, url: URL) {
        super.didFinishRecording(coordinator: coordinator, url: url)
    
        hud.noticeLoading()
        splitVideoFileUrlFps(splitFileUrl: url, fps: 2) { [weak self] (ret, images) in
            DispatchQueue.main.async {
                if images.count > 0 {
                    self?.hud.noticeHidden()
                    
                    self?.videoImages = images
                    
                    self?.bottomBar.isHidden = false
                    self?.recordBar.isHidden = true
                }else {
                    self?.hud.failureHidden("未获取到视屏，请重新拍摄", nil)
                }
            }
        }
    }

}

extension STVideoRecordingViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ctrl = segue.destination as? STVideoCoverChoseViewController {
            ctrl.prepare(parameters: ["data": videoImages])
        }else if let ctrl = segue.destination as? STPublishVideoViewController {
            ctrl.prepare(parameters: ["image": videoImages.first!])
        }
    }
}
