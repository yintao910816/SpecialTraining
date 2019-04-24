//
//  TYVideoPlay.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/20.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift

class TYVideoPlayer {
    
    private var urlString: String = ""
    private var playView: UIView!
    
    private var player: AVPlayer!
    
    private let disposeBag = DisposeBag()
    
    public let progressObser = PublishSubject<CGFloat>()
    public let statusObser = PublishSubject<Bool>()

    deinit {
        PrintLog("已释放 -- \(self)")
        if player.rate == 1 { player.pause() }
    }
    
    init() { }
    
    convenience init(with url: String, playView: UIView) {
        self.init()
        
        urlString = url
        self.playView = playView
        
        configPlay()
    }
    
    private func configPlay() {
        PrintLog("视屏播放地址：\(urlString)")

        guard let url = URL.init(string: urlString) else {
            NoticesCenter.alert(title: "提示", message: "播放地址不正确")
            return
        }
        // AVPlayerItem用来管理视频资源，一条item对应一个视频资源
        let playerItem = AVPlayerItem(url: url)
        // 使用item，初始化avplayer
        player = AVPlayer(playerItem: playerItem)
        // 使用avplayer初始化AVPlayerLayer，将AVPlayerLayer添加到view上
        let layer = AVPlayerLayer(player: player)
        layer.backgroundColor = UIColor.black.cgColor
        playView.layer.addSublayer(layer)
        layer.frame = playView.bounds
        layer.videoGravity = AVLayerVideoGravity.resizeAspect
        
        playerItem.rx.observe(CGFloat.self, "loadedTimeRanges")
            .map({ [weak self] progress -> CGFloat in
                guard let strongSelf = self else { return -1 }
                let loadedTime = strongSelf.avalableDurationWithplayerItem()
                let totalTime = CMTimeGetSeconds(playerItem.duration)
                let percent: CGFloat = CGFloat(loadedTime/totalTime)
                PrintLog("视屏缓冲进度 -- \(percent)")
                return percent
            })
            .bind(to: progressObser)
            .disposed(by: disposeBag)

        playerItem.rx.observe(AVPlayerItem.Status.self, "status")
            .map({ statue -> Bool in
                return statue == AVPlayerItem.Status.readyToPlay
            })
            .bind(to: statusObser)
            .disposed(by: disposeBag)
    }
    
    public func preparePlay(with url: String, playView: UIView) {
        urlString = url
        self.playView = playView
        
        configPlay()
    }
    
    public func play() {
        if player.rate == 0 {
            player.play()
        }
    }
    
    public func pause() {
        if player.rate == 1 {
            player.pause()
        }
    }
}

extension TYVideoPlayer {
    
    func avalableDurationWithplayerItem() -> TimeInterval{
        guard let loadedTimeRanges = player.currentItem?.loadedTimeRanges, let first = loadedTimeRanges.first else { return 0 }
        
        let timeRange = first.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSecound = CMTimeGetSeconds(timeRange.duration)
        let result = startSeconds + durationSecound
        return result
    }
}
