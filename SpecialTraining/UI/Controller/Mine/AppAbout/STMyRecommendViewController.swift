//
//  STMyRecommendViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/4/23.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STMyRecommendViewController: BaseViewController {

    @IBOutlet weak var redBagView: UIImageView!
    @IBOutlet weak var backTopCns: NSLayoutConstraint!
    
    @IBAction func actions(_ sender: UIButton) {
        if sender.tag == 100 {
            navigationController?.popViewController(animated: true)
        }else if sender.tag == 101 {
            // 分享
            STHelper.presentShare(self, "优学乐秀", "测试分享", "推荐有奖_01", nil)
        }
    }

    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "recommendAwardSegue", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        backTopCns.constant += LayoutSize.fitTopArea
        redBagView.loadGif(name: "红包")
    }
}