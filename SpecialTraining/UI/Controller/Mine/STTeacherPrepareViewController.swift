//
//  STTeacherPrepareViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/5.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STTeacherPrepareViewController: BaseViewController {

    @IBOutlet weak var contentOutlet: PlaceholderTextView!
    
    override func setupUI() {
        contentOutlet.placeholder = "请输入备课内容"
        contentOutlet.font = UIFont.systemFont(ofSize: 14)
    }
    
    override func rxBind() {
        
    }
    
}
