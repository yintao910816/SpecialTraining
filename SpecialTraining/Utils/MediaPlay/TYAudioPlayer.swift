//
//  TYAudioPlayer.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/21.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import AVFoundation

class TYAudioPlayer: NSObject {
    
    static let share = TYAudioPlayer()
    
    private var player: AVAudioPlayer!
    private let session = AVAudioSession.sharedInstance()
    
    deinit {
        PrintLog("释放了：\(self)")
    }
    
    override init() {
        super.init()
    }
    
    func play(with filePath: String) {
        PrintLog("播放文件路径 ==\(filePath)")

        initSession()
//        if player != nil {
//            stop()
//        }
        
        guard let audioData = FileManager.default.contents(atPath: filePath) else {
            NoticesCenter.alert(title: "播放失败", message: "播放地址错误")
            return
        }
        
        do {
            player = try AVAudioPlayer(data: audioData)
            player.delegate = self
            player.prepareToPlay()
            player.play()
        }catch {
            NoticesCenter.alert(title: "播放失败", message: error.localizedDescription)
            return
        }
    }
    
    public func pause() {
        if player != nil {
            if player.isPlaying == true {
                player.pause()
            }
        }
    }
    
    public func play() {
        if player != nil {
            if player.isPlaying == false{
                player.play()
            }
        }
    }
    
    public func stop() {
        if player != nil {
            player.stop()
        }
    }
}

extension TYAudioPlayer {
    
    private func initSession() {
        do{
            //  设置会话类别
            if #available(iOS 10.0, *) {
                try session.setCategory(.playback, mode: .moviePlayback)
            }
            else {
                session.perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.playback)
            }
            //  激活会话
            try session.setActive(true)
        }catch {
            PrintLog(error)
            return
        }
    }
}

extension TYAudioPlayer: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
}
