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

class TYVideoPlayer: UIView {
    
    private var bgProgress: UIView!
    // 缓冲进度
    private var prepareProgress: UIView!
    // 播放进度
    private var playProgress: UIView!
    // 封面
    private var videoCover: UIImageView!
    // 底部操作栏
    private var bottomBarView: UIView!
    // 视屏标题
    private var videoTitleLable: UILabel!
    // 播放按钮
    private var playButton: UIButton!
    
    private var videoModel: VideoData = VideoData()
    private var totleTime: TimeInterval = 1.0
    private var timer: CountdownTimer!

    private var player: AVPlayer!
    private var playLayer: AVPlayerLayer!
    
    private var hud = NoticesCenter()
    private let disposeBag = DisposeBag()
    
    public let progressObser = PublishSubject<CGFloat>()
//    public let statusObser = PublishSubject<Bool>()

    deinit {
        PrintLog("已释放 -- \(self)")
        if player != nil {
            if player.rate == 1 {
                player.pause()
                stop()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        backgroundColor = .black
        
        videoCover = UIImageView()
        videoCover.backgroundColor = .clear
        videoCover.isUserInteractionEnabled = true
        videoCover.contentMode = .scaleAspectFill
        videoCover.clipsToBounds = true
        
        playButton = UIButton()
        playButton.setBackgroundImage(UIImage.init(named: "btn_play"), for: .normal)
        playButton.addTarget(self, action: #selector(startPlay), for: .touchUpInside)
        
        bottomBarView = UIView()
        bottomBarView.backgroundColor = .clear
        
        videoTitleLable = UILabel()
        videoTitleLable.font = UIFont.systemFont(ofSize: 15)
        videoTitleLable.textColor = .white
        
        bgProgress = UIView()
        bgProgress.backgroundColor = RGB(220, 220, 220)
        
        prepareProgress = UIView()
        prepareProgress.backgroundColor = .white
        
        playProgress = UIView()
        playProgress.backgroundColor = RGB(243, 153, 52)
        
        addSubview(videoCover)
        addSubview(bottomBarView)
        
        bottomBarView.addSubview(videoTitleLable)
        
        videoCover.addSubview(playButton)
        bottomBarView.addSubview(bgProgress)
        bgProgress.addSubview(prepareProgress)
        bgProgress.addSubview(playProgress)
        
        var bottom: CGFloat = 0
        if #available(iOS 11, *) {
            if let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w {
                bottom = unwrapedWindow.safeAreaInsets.bottom
            }
        }
        
        bottomBarView.snp.makeConstraints{
            $0.bottom.equalTo(-bottom)
            $0.left.right.equalTo(0)
            $0.height.equalTo(50)
        }
        
        videoTitleLable.snp.makeConstraints{
            $0.left.equalTo(20)
            $0.centerY.equalTo(bottomBarView.snp.centerY)
        }
        
        videoCover.snp.makeConstraints{
            $0.top.left.right.equalTo(0)
            $0.bottom.equalTo(bottomBarView.snp.top)
        }
        
        playButton.snp.makeConstraints{
            $0.center.equalTo(videoCover.snp.center)
            $0.size.equalTo(CGSize.init(width: 45, height: 45))
        }
        
        bgProgress.snp.makeConstraints {
            $0.left.bottom.equalTo(0)
            $0.width.equalTo(PPScreenW)
            $0.height.equalTo(1)
        }
        
        prepareProgress.snp.makeConstraints {
            $0.left.bottom.equalTo(0)
            $0.width.equalTo(1)
            $0.height.equalTo(bgProgress.snp.height)
        }
        
        playProgress.snp.makeConstraints {
            $0.left.bottom.equalTo(0)
            $0.width.equalTo(1)
            $0.height.equalTo(bgProgress.snp.height)
        }
    }
    
    public func prepare(with model: VideoData) {
        videoModel = model
        videoCover.setImage(model.cover)
        videoTitleLable.text = model.title
    }
    
    @objc public func startPlay() {
        configPlay()
        playButton.isHidden = true
    }
    
    public func pause() {
        if player.rate == 1 {
            player.pause()
        }
    }
    
    public func stop() {
        playLayer.removeFromSuperlayer()
        playLayer = nil
        player = nil
    }
}

extension TYVideoPlayer {
    
    private func configPlay() {
        hud.noticeLoading(nil, UIApplication.shared.keyWindow)
        
        guard let url = URL.init(string: videoModel.videoURL) else {
            hud.failureHidden("播放地址不正确")
            return
        }
        // AVPlayerItem用来管理视频资源，一条item对应一个视频资源
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        playLayer = AVPlayerLayer(player: player)
        playLayer.backgroundColor = UIColor.clear.cgColor
        videoCover.layer.addSublayer(playLayer)
        
        playLayer.frame = bounds
        playLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        playerItem.rx.observe(CGFloat.self, "loadedTimeRanges")
            .map({ [weak self] progress -> CGFloat in
                guard let strongSelf = self else { return -1 }
                
                let loadedTime = strongSelf.avalableDurationWithplayerItem()
                let totalTime = CMTimeGetSeconds(playerItem.duration)
                let percent: CGFloat = CGFloat(loadedTime/totalTime)
                if percent >= 0 && percent != CGFloat.nan {
                    strongSelf.totleTime = totalTime
                    let pregress: CGFloat = PPScreenW * percent
                    strongSelf.prepareProgress.snp.updateConstraints{ $0.width.equalTo(pregress) }
                }
                PrintLog("视屏缓冲进度 -- \(percent)")
                if percent >= 1 {
                    strongSelf.hud.noticeHidden()
                    strongSelf.readyPlay()
                }
                return percent
            })
            .bind(to: progressObser)
            .disposed(by: disposeBag)
        
        //        playerItem.rx.observe(AVPlayerItem.Status.self, "status")
        //            .map({ statue -> Bool in
        //                return statue == AVPlayerItem.Status.readyToPlay
        //            })
        //            .do(onNext: { [weak self] flag in
        //                if flag == true { self?.hud.noticeHidden() }
        //            })
        //            .bind(to: statusObser)
        //            .disposed(by: disposeBag)
    }

    private func readyPlay() {
        if player.rate == 0 {
            if timer == nil {
                let totleInt: Int = Int(round(totleTime))
                timer = CountdownTimer.init(timeInterval: 1, totleCount: totleInt)
                timer.countTime.asDriver()
                    .drive(onNext: { [weak self] count in
                        guard let strongSelf = self else { return }
                        let percent: CGFloat = CGFloat(count)/CGFloat(totleInt)
                        print(strongSelf.playProgress.width )
                        let pregress: CGFloat = PPScreenW * percent
                        strongSelf.playProgress.snp.updateConstraints{ $0.width.equalTo(pregress) }
                        print(count)
                        if count >= totleInt {
                            strongSelf.playButton.isHidden = false
                            strongSelf.stop()
                        }
                    })
                    .disposed(by: disposeBag)
            }
            
            player.play()
            timer.timerStar()
        }
    }
    
    private func avalableDurationWithplayerItem() -> TimeInterval{
        if player == nil { return 0 }
        
        guard let loadedTimeRanges = player.currentItem?.loadedTimeRanges, let first = loadedTimeRanges.first else { return 0 }
        
        let timeRange = first.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSecound = CMTimeGetSeconds(timeRange.duration)
        let result = startSeconds + durationSecound
        return result
    }
}

class VideoData {
    var cover: String = ""
    var title: String = ""
    var videoURL: String = ""
    
    class func creat(with videoListModel: VideoListModel) ->VideoData {
        let m = VideoData()
        m.cover = videoListModel.cover_url
        m.title = videoListModel.title
        m.videoURL = videoListModel.video_url
        return m
    }
    
    class func creat(with model: CourseDetailVideoModel) ->VideoData {
        let m = VideoData()
        m.cover = model.res_image
        m.title = model.res_title
        m.videoURL = model.res_url
        return m
    }

}
