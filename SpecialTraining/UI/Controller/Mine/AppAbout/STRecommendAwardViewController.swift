//
//  STRecommendAwardViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/4/23.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STRecommendAwardViewController: BaseViewController {

    private var recommendAwardImgV1: UIImageView!
    private var recommendAwardImgV2: UIImageView!
    @IBOutlet weak var backTopCns: NSLayoutConstraint!
    
    @IBOutlet weak var scrollOutlet: UIScrollView!
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        if #available(iOS 11, *) {
            scrollOutlet.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
        backTopCns.constant += LayoutSize.fitTopArea
        creatImgV()
    }
    
    private func creatImgV() {
        recommendAwardImgV1 = UIImageView.init(image: UIImage.init(named: "推荐有奖_01"))
        recommendAwardImgV1.contentMode = .scaleToFill
        recommendAwardImgV2 = UIImageView.init(image: UIImage.init(named: "推荐有奖_02"))
        recommendAwardImgV2.contentMode = .scaleToFill

        scrollOutlet.addSubview(recommendAwardImgV1)
        scrollOutlet.addSubview(recommendAwardImgV2)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let image1Size = recommendAwardImgV1.image?.size ?? .zero
        let image2Size = recommendAwardImgV2.image?.size ?? .zero
        guard image1Size.equalTo(.zero) == false || image2Size.equalTo(.zero) == false else {
            return
        }
        
        let h1: CGFloat = view.width * image1Size.height / image1Size.width
        let h2: CGFloat = view.width * image2Size.height / image1Size.width

        recommendAwardImgV1.frame = .init(x: 0, y: 0, width: view.width, height: h1)
        recommendAwardImgV2.frame = .init(x: 0, y: recommendAwardImgV1.frame.maxY, width: view.width, height: h2)
        
        scrollOutlet.contentSize = .init(width: view.width, height: recommendAwardImgV2.frame.maxY)
    }
}
