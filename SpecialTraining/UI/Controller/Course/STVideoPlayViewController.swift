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
    @IBOutlet weak var playLayer: TYVideoPlayer!
    @IBOutlet weak var videoTitleOutlet: UILabel!
    
    private var player: TYVideoPlayer!
    private var videoModel: CourseDetailVideoModel!
    
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
        titleOutlet.text = videoModel.res_title
        
        playLayer.prepare(with: VideoData.creat(with: videoModel))
    }
    
    override func rxBind() {
//        player.statusObser
//            .subscribe(onNext: { [weak self] reday in
//                if reday {
//                    self?.player.play()
//                }
//            })
//            .disposed(by: disposeBag)
    }
}
