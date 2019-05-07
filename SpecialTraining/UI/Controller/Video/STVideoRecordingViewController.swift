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
    
    @IBOutlet weak var recordBar: UIView!
    @IBOutlet weak var cancleTopCns: NSLayoutConstraint!
    
    @IBOutlet weak var transforCamamerOutlet: UIButton!
    @IBOutlet weak var recordButtonOutlet: UIButton!
    @IBOutlet weak var nextOutlet: UIButton!
    @IBOutlet weak var closeOutlet: UIButton!
    @IBOutlet weak var cancleOutlet: UIButton!
   
    @IBOutlet weak var timeBgOutlet: UIView!
    @IBOutlet weak var timeOutlet: UILabel!

    private var timer: CountdownTimer!
    private let hud = NoticesCenter()
    private var videoImages: [UIImage]!
    private var videoURL: String = ""
    
    @IBAction func actions(_ sender: UIButton) {
        if sender == recordButtonOutlet {
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                // 开始录制
                cancleOutlet.setTitle("取消", for: .normal)
                startRecord()
                isRecording()
                timer.timerStar()
            }else {
                // 停止录制
                stopRecord()
                timer.timerPause()
            }
        }else if sender == transforCamamerOutlet {
            // 切换摄像头
        }else if sender == nextOutlet {
            // 下一步
            performSegue(withIdentifier: "publishSegue", sender: nil)
        }else if sender == closeOutlet {
            // 关闭
            isCancle = true
            timer.timerPause()
            stopRecord()
            dismiss(animated: true, completion: nil)
        }else if sender == cancleOutlet {
            if cancleOutlet.titleLabel?.text == "重新录制" {
                recordButtonOutlet.isSelected = true
                cancleOutlet.setTitle("取消", for: .normal)
                startRecord()
                isRecording()
                timer.timerStar()
            }else {
                // 取消
                timer.timerPause()
                recordButtonOutlet.isSelected = false
                isCancle = true
                stopRecord()
                unRecord()
            }
        }
        
        ////            // 选择封面
        ////            performSegue(withIdentifier: "choseCoverSegue", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        unRecord()
    }
    
    override func setupUI() {
        cancleTopCns.constant += LayoutSize.fitTopArea
        
        timer = CountdownTimer.init(totleCount: 15)
        
        let frame = CGRect.init(x: 0, y: 0, width: nextOutlet.width, height: nextOutlet.height)
        nextOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
    }
    
    override func rxBind() {
        timer.countTime.asDriver()
            .drive(onNext: { [weak self] count in
                if count >= 15 {
                    self?.recordButtonOutlet.isSelected = false
                    self?.stopRecord()
                }
                self?.timeOutlet.text = "00:\(count.fixInt)/00:15"
            })
            .disposed(by: disposeBag)
    }
    
    override func didFinishRecording(coordinator: CaptureSessionCoordinator, url: URL) {
        super.didFinishRecording(coordinator: coordinator, url: url)
    
        if isCancle == false {
            videoURL = url.path
            hud.noticeLoading()
            splitVideoFileUrlFps(splitFileUrl: url, fps: 2) { [weak self] (ret, images) in
                DispatchQueue.main.async {
                    if images.count > 0 {
                        self?.hud.noticeHidden()
                        self?.videoImages = images
                        
                        self?.cancleOutlet.setTitle("重新录制", for: .normal)
                        self?.finishRecord()
                    }else {
                        self?.hud.failureHidden("未获取到视屏，请重新拍摄", nil)
                        self?.cancleOutlet.setTitle("取消", for: .normal)
                        self?.unRecord()
                    }
                    self?.isCancle = false
                }
            }
        }else {
            unRecord()
            isCancle = false
        }
    }

}

extension STVideoRecordingViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ctrl = segue.destination as? STVideoCoverChoseViewController {
            ctrl.prepare(parameters: ["data": videoImages])
        }else if let ctrl = segue.destination as? STPublishVideoViewController {
            ctrl.prepare(parameters: ["image": videoImages.first!, "videoURL": videoURL])
        }
    }
}

extension STVideoRecordingViewController {
    // 未开始录制
    private func unRecord() {
        timeBgOutlet.isHidden = true
        
        transforCamamerOutlet.isHidden = false
        recordButtonOutlet.isHidden = false
        nextOutlet.isHidden = true
        closeOutlet.isHidden = false
        cancleOutlet.isHidden = true
    }
    
    // 正在录制
    private func isRecording() {
        timeBgOutlet.isHidden = false

        transforCamamerOutlet.isHidden = true
        recordButtonOutlet.isHidden = false
        nextOutlet.isHidden = true
        closeOutlet.isHidden = true
        cancleOutlet.isHidden = false
    }
    
    /// 录制完成
    private func finishRecord() {
        timeBgOutlet.isHidden = true

        transforCamamerOutlet.isHidden = true
        recordButtonOutlet.isHidden = true
        nextOutlet.isHidden = false
        closeOutlet.isHidden = false
        cancleOutlet.isHidden = false
    }

}
