

//
//  CourseTimeCell.swift
//  SpecialTraining
//
//  Created by yintao on 2018/12/17.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class CourseTimeCell: BaseTBCell {

    @IBOutlet weak var iconOutlet: UIButton!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var stuTimeOutlet: UILabel!
    @IBOutlet weak var classLevelOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: ClassTimeItemModel! {
        didSet {
            iconOutlet.setImage(model.teacher_pic)
            nameOutlet.text = model.teacher_name
            stuTimeOutlet.text = model.stuTime
            
            if let level = ClassLevel(rawValue: model.class_level) {
                classLevelOutlet.text = level.levelText
            }else {
                classLevelOutlet.text = nil
            }
        }
    }
}
