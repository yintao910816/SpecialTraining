//
//  fileOutputCoordinator.swift
//  captureDemo
//
//  Created by 区块国际－yin on 2017/3/22.
//  Copyright © 2017年 blog.aiyinyu.com. All rights reserved.
//

import UIKit
import AVFoundation

class fileOutputCoordinator: CaptureSessionCoordinator, AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        delegate?.didFinishRecording(coordinator: self, url: outputFileURL)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        delegate?.coordinatorDidBeginRecording(coordinator: self)
    }
    
    var movieFileOutput: AVCaptureMovieFileOutput?
    
    override init() {
        super.init()
        movieFileOutput = AVCaptureMovieFileOutput()
        _ = addOutput(output: movieFileOutput!, capSession: captureSession!)
    }
    override func startRecording() {
        let fm = YfileManager()
        let tempUrl = fm.tempFileUrl()
        movieFileOutput?.startRecording(to: tempUrl, recordingDelegate: self)
    }
    override func stopRecording() {
        movieFileOutput?.stopRecording()
    }
    
}
