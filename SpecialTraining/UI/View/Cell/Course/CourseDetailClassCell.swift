
//
//  CourseDetailClassCell.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/20.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class CourseDetailClassCell: UITableViewCell {

    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var classNameOutlet: UILabel!
    @IBOutlet weak var timeOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: CourseDetailClassModel! {
        didSet {
            coverOutlet.setImage(model.teacher_pic)
            classNameOutlet.text = model.class_name
            timeOutlet.text = model.start_time
        }
    }
}
