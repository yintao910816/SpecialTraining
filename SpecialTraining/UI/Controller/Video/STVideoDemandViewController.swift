//
//  STVideoDemandViewController.swift
//  SpecialTraining
//
//  Created by sw on 03/12/2018.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STVideoDemandViewController: BaseViewController {

    @IBOutlet weak var navHeightCns: NSLayoutConstraint!
    @IBOutlet weak var userIconOutlet: UIButton!
    @IBOutlet weak var nickNameOutlet: UILabel!
    
    @IBOutlet weak var videoPlayer: TYVideoPlayer!
    
    private var player: TYVideoPlayer!
    
    public var videoInfoModel: VideoListModel!

    @IBAction func actions(_ sender: UIButton) {
        switch sender.tag {
        case 200:
            navigationController?.popViewController(animated: true)
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        navHeightCns.constant += LayoutSize.fitTopArea
        
        userIconOutlet.setImage(STHelper.share.loginUser?.headimgurl)
        nickNameOutlet.text = STHelper.share.loginUser?.nickname
        
        videoPlayer.prepare(with: VideoData.creat(with: videoInfoModel))
    }
    
    override func rxBind() {
//        player.statusObser
//            .subscribe(onNext: { [weak self] reday in
//                if reday { self?.player.play() }
//            })
//            .disposed(by: disposeBag)
    }
}
