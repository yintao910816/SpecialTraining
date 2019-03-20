//
//  STVideoPlayViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/20.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxSwift

class STVideoPlayViewController: BaseViewController {

    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var topBarHeightCns: NSLayoutConstraint!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var nickNameOutlet: UILabel!
    @IBOutlet weak var playLayer: UIView!
    @IBOutlet weak var videoTitleOutlet: UILabel!
    
    private var player: TYVideoPlayer!
    private var videoModel: CourseDetailVideoModel!
    
    private var hud = NoticesCenter()

    public func preparePlay(videoInfo: CourseDetailVideoModel){
        videoModel = videoInfo
    }
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.25) {
            self.topBar.isHidden = !self.topBar.isHidden
            self.bottomBar.isHidden = !self.bottomBar.isHidden
        }
    }
    
    @IBAction func actions(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func setupUI() {
        topBarHeightCns.constant += LayoutSize.fitTopArea
        
        hud.noticeLoading()
        player = TYVideoPlayer()
        playLayer.layoutIfNeeded()
        player.preparePlay(with: videoModel.res_url, playView: playLayer)
        
        videoTitleOutlet.text = videoModel.res_title
    }
    
    override func rxBind() {
        player.statusObser
            .subscribe(onNext: { [weak self] reday in
                self?.hud.noticeHidden()
                if reday { self?.player.play() }
            }, onError: { [weak self] error in
                self?.hud.failureHidden(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
