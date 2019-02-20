//
//  fileOutputViewController.swift
//  captureDemo
//
//  Created by 区块国际－yin on 2017/3/21.
//  Copyright © 2017年 blog.aiyinyu.com. All rights reserved.
//

import UIKit

class fileOutputViewController: BaseViewController, captureSessionCoordinatorDelegate {

    var captureSessionCoordinator: fileOutputCoordinator?
    var recording: Bool = false
    var dismissing: Bool = false
    /// 是否是取消视频录制
    var isCancle: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        captureSessionCoordinator = fileOutputCoordinator()
        captureSessionCoordinator?.setDelegate(capDelegate: self, queue: DispatchQueue(label: "fileOutputCoordinator"))
        confiureCamper()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///  关闭当前视图
    func closeCameral(_ sender: Any) {
        if recording {
            dismissing = true
        } else {
            stopPipelineAndDismiss()
        }
    }

    func stopRecord() {
        captureSessionCoordinator?.stopRecording()
    }
    
    func startRecord() {
        UIApplication.shared.isIdleTimerDisabled = true
        
        captureSessionCoordinator?.startRecording()
        recording = true
    }
    
    func confiureCamper() {
        let cameraViewlayer = captureSessionCoordinator?.previewLayerSetting()
        cameraViewlayer?.frame = view.bounds
        view.layer.insertSublayer(cameraViewlayer!, at: 0)
        captureSessionCoordinator?.startRunning()
        
    }
    func stopPipelineAndDismiss() {
        captureSessionCoordinator?.stopRunning()
        dismiss(animated: true, completion: nil)
        dismissing = false
    }
    func coordinatorDidBeginRecording(coordinator: CaptureSessionCoordinator) {

    }
    
    func didFinishRecording(coordinator: CaptureSessionCoordinator, url: URL) {
        UIApplication.shared.isIdleTimerDisabled = false
        recording = false
        if isCancle == false {
            let fm = YfileManager()
            fm.copFileToCameraRoll(fileUrl: url)
        }
        if dismissing { stopPipelineAndDismiss() }
    }

}

/// 视频分解成帧
/// - parameter fileUrl                 : 视频地址
/// - parameter fps                     : 自定义帧数 每秒内取的帧数
/// - parameter splitCompleteClosure    : 回调
func splitVideoFileUrlFps(splitFileUrl:URL, fps:Float, splitCompleteClosure: @escaping ((Bool, [UIImage]) ->Void)) {
        
    var splitImages = [UIImage]()
    let optDict = NSDictionary(object: NSNumber(value: false), forKey: AVURLAssetPreferPreciseDurationAndTimingKey as NSCopying)
    let urlAsset = AVURLAsset(url: splitFileUrl, options: optDict as? [String : Any])
    
    let cmTime = urlAsset.duration
    let durationSeconds: Float64 = CMTimeGetSeconds(cmTime) //视频总秒数
    
    var times = [NSValue]()
    let totalFrames: Float64 = durationSeconds * Float64(fps) //获取视频的总帧数
    var timeFrame: CMTime
    
    for i in 0...Int(totalFrames) {
        timeFrame = CMTimeMake(value: Int64(i), timescale: Int32(fps)) //第i帧， 帧率
        let timeValue = NSValue(time: timeFrame)
        
        times.append(timeValue)
    }
    
    let imgGenerator = AVAssetImageGenerator(asset: urlAsset)
    imgGenerator.requestedTimeToleranceBefore = CMTime.zero //防止时间出现偏差
    imgGenerator.requestedTimeToleranceAfter = CMTime.zero
    
    let timesCount = times.count
    
    //获取每一帧的图片
    imgGenerator.generateCGImagesAsynchronously(forTimes: times) { (requestedTime, image, actualTime, result, error) in
        
        //times有多少次body就循环多少次。。。。
        var isSuccess = false
        switch (result) {
        case AVAssetImageGenerator.Result.cancelled:
            splitCompleteClosure(false, [UIImage]())
        case AVAssetImageGenerator.Result.failed:
            splitCompleteClosure(false, [UIImage]())
        case AVAssetImageGenerator.Result.succeeded:
            let framImg = UIImage(cgImage: image!)
            splitImages.append(framImg)
            
            if (Int(requestedTime.value) == (timesCount-1)) { //最后一帧时 回调赋值
                isSuccess = true
                splitCompleteClosure(isSuccess, splitImages)
                print("completed")
            }
        }
    }
}
