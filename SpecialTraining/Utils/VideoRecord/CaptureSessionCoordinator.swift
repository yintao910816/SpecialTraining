//
//  CaptureSessionCoordinator.swift
//  captureDemo
//
//  Created by 区块国际－yin on 2017/3/22.
//  Copyright © 2017年 blog.aiyinyu.com. All rights reserved.
//

import UIKit
import AVFoundation

/// 线程加锁
///
/// - Parameters:
///   - lock: 加锁对象
///   - dispose: 执行闭包函数,
func synchronized(_ lock: AnyObject,dispose: ()->()) {
    objc_sync_enter(lock)
    dispose()
    objc_sync_exit(lock)
}
protocol captureSessionCoordinatorDelegate: class {
    func coordinatorDidBeginRecording(coordinator: CaptureSessionCoordinator)
    func didFinishRecording(coordinator: CaptureSessionCoordinator,url: URL)
}

class CaptureSessionCoordinator: NSObject {
    
    var captureSession: AVCaptureSession?
    var cameraDevice: AVCaptureDevice?
    var delegateCallQueue: DispatchQueue?
    weak var delegate: captureSessionCoordinatorDelegate?
    
    private var sessionQueue = DispatchQueue(label: "coordinator.Session")
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    override init() {
        super.init()
        captureSession = setupCaptureSession()
    }
    
    public func setDelegate(capDelegate: captureSessionCoordinatorDelegate,queue: DispatchQueue) {
        synchronized(self) {
            delegate = capDelegate
            if delegateCallQueue != queue {
                delegateCallQueue = queue
            }
        }
    }
    
//MARK:            ________________Session Setup________________
    private func setupCaptureSession() -> AVCaptureSession {
        let session = AVCaptureSession()
//        session.sessionPreset = AVCaptureSessionPresetiFrame1280x720
        
        if !addDefaultCameraInputToCaptureSession(capSession: session) {
            PrintLog("failed to add camera input to capture session")
        }
        if !addDefaultMicInputToCaptureSession(capSession: session) {
            PrintLog("failed to add mic input to capture session")
        }
        return session
    }
    
    private func addDefaultCameraInputToCaptureSession(capSession: AVCaptureSession) -> Bool {
        do {
            var videoDevice: AVCaptureDevice?
            if let defaultVideoDevice = AVCaptureDevice.default(for: AVMediaType.video) {
                videoDevice = defaultVideoDevice
            }else if #available(iOS 10.0, *){
                if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) {
                    videoDevice = backCameraDevice
                }else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) {
                    videoDevice = frontCameraDevice
                }
            }else if #available(iOS 10.2, *),
                let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back){
                videoDevice = dualCameraDevice
            }

            if videoDevice == nil {
                return false
            }else {
                let cameraInput = try AVCaptureDeviceInput(device: videoDevice!)
                let success = addInput(input: cameraInput, capSession: capSession)
                cameraDevice = cameraInput.device
                return success
            }
        } catch let error as NSError {
            PrintLog("error configuring camera input: \(error.localizedDescription)")
            return false
        }
    }
    
    private func addDefaultMicInputToCaptureSession(capSession: AVCaptureSession) -> Bool {
        do {
            var videoDevice: AVCaptureDevice?
            if let defaultVideoDevice = AVCaptureDevice.default(for: AVMediaType.video) {
                videoDevice = defaultVideoDevice
            }else if #available(iOS 10.0, *){
                if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) {
                    videoDevice = backCameraDevice
                }else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) {
                    videoDevice = frontCameraDevice
                }
            }else if #available(iOS 10.2, *),
                let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back){
                videoDevice = dualCameraDevice
            }
            
            if videoDevice == nil {
                return false
            }else {
                let micInput = try AVCaptureDeviceInput(device: videoDevice!)
                let success = addInput(input: micInput, capSession: capSession)
                return success
            }
        } catch let error as NSError {
            PrintLog("error configuring mic input: \(error.localizedDescription)")
            return false
        }
    }
    
    //MARK:            ________________Public Api________________
    
    func addInput(input: AVCaptureDeviceInput,capSession: AVCaptureSession) -> Bool {
        if capSession.canAddInput(input) {
            capSession.addInput(input)
            return true
        }
        PrintLog("input error")
        return false
    }
    func addOutput(output: AVCaptureOutput,capSession: AVCaptureSession) -> Bool {
        if capSession.canAddOutput(output) {
            capSession.addOutput(output)
            return true
        }
        PrintLog("output error")
        return false
    }
    func startRunning() {
        sessionQueue.async {
            self.captureSession?.startRunning()
        }
    }
    func stopRunning() {
        sessionQueue.async {
            self.stopRunning()
            self.captureSession?.stopRunning()
        }
    }
    func startRecording() {
        // 子类继承后重写
    }
    func stopRecording() {
        // 子类继承后重写
    }
    
    func previewLayerSetting() -> AVCaptureVideoPreviewLayer {
        let existPer = (previewLayer == nil)
        let existCap = (captureSession != nil)
        let initPer = existPer && existCap
        if initPer {
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        }
        return previewLayer!
    }
    
}
