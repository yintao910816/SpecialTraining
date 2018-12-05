//
//  STTreasureExchangeViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/5.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STTreasureExchangeViewController: BaseTableViewController {

    @IBOutlet weak var describInputOutlet: PlaceholderTextView!
   
    override func setupUI() {
        describInputOutlet.placeholder = "描述一下宝贝的转手原因、入手渠道和使用感受"
        describInputOutlet.font = UIFont.systemFont(ofSize: 14)
    }
    
    override func rxBind() {
        
    }
}
