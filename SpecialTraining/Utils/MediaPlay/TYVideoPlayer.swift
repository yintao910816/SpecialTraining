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
    
    private var bgProgress: UIView!
    // 缓冲进度
    private var prepareProgress: UIView!
    // 播放进度
    private var playProgress: UIView!
    
    private var totleTime: TimeInterval = 1.0
    private var timer: CountdownTimer!

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
        
        setupView()
        configPlay()
    }
    
    private func setupView() {
        bgProgress = UIView()
        bgProgress.backgroundColor = .red//RGB(220, 220, 220)
        
        prepareProgress = UIView()
        prepareProgress.backgroundColor = .white
        
        playProgress = UIView()
        playProgress.backgroundColor = RGB(243, 153, 52)
        
        playView.addSubview(bgProgress)
        bgProgress.addSubview(prepareProgress)
        bgProgress.addSubview(playProgress)
        
        playView.bringSubviewToFront(bgProgress)
        
        var bottom: CGFloat = 0
        if #available(iOS 11, *) {
            if let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w {
                bottom = unwrapedWindow.safeAreaInsets.bottom
            }
        }
        
        bgProgress.snp.makeConstraints {
            $0.left.equalTo(0)
            $0.width.equalTo(playView.width)
            $0.height.equalTo(1)
            $0.bottom.equalTo(-bottom)
        }
        
        prepareProgress.snp.makeConstraints {
            $0.left.bottom.equalTo(0)
            $0.width.equalTo(playView.width)
            $0.height.equalTo(bgProgress.snp.height)
        }
        
        playProgress.snp.makeConstraints {
            $0.left.bottom.equalTo(0)
            $0.width.equalTo(playView.width)
            $0.height.equalTo(bgProgress.snp.height)
        }
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
                if totalTime > 0 {
                    strongSelf.totleTime = totalTime
                    PrintLog("video totleTime - \(totalTime)")
                    let pregress: CGFloat = strongSelf.playView.width * percent
                    strongSelf.prepareProgress.snp.updateConstraints{ $0.width.equalTo(pregress) }
                }
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
        
        if bgProgress == nil {
            setupView()
        }
        
        configPlay()
    }
    
    public func play() {
        if player.rate == 0 {
            if timer == nil {
                let totleInt: Int = Int(round(totleTime))
                timer = CountdownTimer.init(timeInterval: 1, totleCount: totleInt)
                timer.countTime.asDriver()
                    .drive(onNext: { [weak self] count in
                        guard let strongSelf = self else { return }
                        let percent: CGFloat = CGFloat(count/totleInt)
                        let pregress: CGFloat = strongSelf.playView.width * percent
                        strongSelf.playProgress.snp.updateConstraints{ $0.width.equalTo(pregress) }
                    })
                    .disposed(by: disposeBag)
            }

            player.play()
            timer.timerStar()
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
