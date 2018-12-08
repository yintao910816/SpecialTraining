//
//  AVCaptureSessionManager.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/8.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class AVCaptureSessionManager {

    /**
     AVCaptureSession 视频捕获 input和output 的桥梁
     videoDevice 视频输入设备
     audioDevice 音频输入设备
     */
    private let captureSession = AVCaptureSession()
    private let videoDevice = AVCaptureDevice.default(for: AVMediaType.video)
    private let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
    private let fileOutPut = AVCaptureMovieFileOutput()
    
    var isRecording = false
    
    var isReady = false
    
    private var tmpFileUrl:URL?
    
    private var viewController: UIViewController!
    
    public weak var delegate: CaptureSessionDelegate?
    
    init(root viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func startRecord() {
        if isReady == true {
            if isRecording == true {
                captureSession.stopRunning()
            }
            captureSession.startRunning()
        }else {
            creatUI()
        }
    }
    
    func stopRecord() {
        captureSession.stopRunning()
    }
    
    func creatUI() {
        //添加视频音频输入设备、添加视频捕获输出
        guard let video = videoDevice else {
            NoticesCenter.alert(title: "提示", message: "不支持录像")
            return
        }
        guard let audio = audioDevice else {
            NoticesCenter.alert(title: "提示", message: "不支持录音")
            return
        }
        do {
            let videoInput  = try AVCaptureDeviceInput.init(device: video)
            let audioInput  = try AVCaptureDeviceInput.init(device: audio)
            
            captureSession.addInput(videoInput)
            captureSession.addInput(audioInput)
            captureSession.addOutput(fileOutPut)
            
            let videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoLayer.frame = viewController.view.bounds
            videoLayer.videoGravity = .resizeAspectFill
            viewController.view.layer.insertSublayer(videoLayer, at: 0)
            isReady = true
            
            captureSession.startRunning()
        } catch {
            isReady = false
            NoticesCenter.alert(title: "提示", message: "设备初始化失败！")
        }
    }
    
    private func openMedia() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //获取相机权限
            let status = AVCaptureDevice.authorizationStatus(for: .metadata)
            switch status {
            case .notDetermined:
                // 第一次触发
                AVCaptureDevice.requestAccess(for: .metadata) { [weak self] _ in self?.openMedia() }
            case .restricted:
                //此应用程序没有被授权访问的照片数据
                NoticesCenter.alert(message: "此应用程序没有被授权访问的照片数据")
            case .denied:
                //用户已经明确否认了这一照片数据的应用程序访问
                NoticesCenter.alert(message: "请前往设置中心授权相册权限")
                break
            case .authorized://已经有权限
                break
            }
        }else {
            NoticesCenter.alert(message: "此设备不支持摄像")
        }
    }

}

extension AVCaptureSessionManager {
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        print("StartRecording 开始")
        isRecording = true
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        isRecording = false
        
        delegate?.capture(didFinishRecordingToOutputFileAt: outputFileURL)

//        var message:String!
//
//        //将录制好的录像保存到照片库中
//        PHPhotoLibrary.shared().performChanges({
//
//            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
//        }) { (isSuccess:Bool, error:Error?) in
//            if isSuccess {
//                message = "保存成功"
//            }else {
//                message = "失败:\(String(describing: error?.localizedDescription))"
//            }
//
//            DispatchQueue.main.async {[weak self] in
//                let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
//                let cancelAction = UIAlertAction(title: "sure", style: .cancel, handler: nil)
//                alertVC.addAction(cancelAction)
//            }
//        }
    }
}

protocol CaptureSessionDelegate: class {
    func capture(didFinishRecordingToOutputFileAt outputFileURL: URL)
}
