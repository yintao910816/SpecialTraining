


//
//  STTeacherInfoViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/10.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STTeacherInfoViewController: BaseViewController {

    @IBOutlet weak var avatarOutlet: UIImageView!
    @IBOutlet weak var teacherNameOutlet: UILabel!
    @IBOutlet weak var levelInfoOutlet: UILabel!
    @IBOutlet weak var teacherInfoOutlet: UILabel!
    
    private var model: ShopDetailTeacherModel!
    
    override func setupUI() {
        navigationItem.title = "老师信息"
        
        avatarOutlet.setImage(model.pic)
        teacherNameOutlet.text = model.teacher_name
        levelInfoOutlet.text = model.teacher_level
        teacherInfoOutlet.text = model.introduce
    }
    
    override func rxBind() {
        
    }
    
    override func prepare(parameters: [String : Any]?) {
        model = (parameters!["model"] as! ShopDetailTeacherModel)
    }
}
