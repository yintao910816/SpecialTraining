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
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var playLayer: UIView!
    @IBOutlet weak var videoTitleOutlet: UILabel!
    
    private var player: TYVideoPlayer!
    private var videoModel: CourseDetailVideoModel!
    
    private var hud = NoticesCenter()

    public func preparePlay(videoInfo: CourseDetailVideoModel){
        videoModel = videoInfo
    }
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.15) {
            if self.topBar.transform.isIdentity == true {
                self.topBar.transform = CGAffineTransform.init(translationX: 0, y: -self.topBar.height)
            }else {
                self.topBar.transform = CGAffineTransform.identity
            }
        }
    }
    
    @IBAction func actions(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func setupUI() {
        topBarHeightCns.constant += LayoutSize.fitTopArea
        
        hud.noticeLoading(nil, UIApplication.shared.keyWindow)
        player = TYVideoPlayer()
        playLayer.layoutIfNeeded()
        player.preparePlay(with: videoModel.res_url, playView: playLayer)
        
        titleOutlet.text = videoModel.res_title
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
