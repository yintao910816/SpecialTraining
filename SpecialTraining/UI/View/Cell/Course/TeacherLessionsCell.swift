



//
//  TeacherLessionsCell.swift
//  SpecialTraining
//
//  Created by yintao on 2019/4/25.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class TeacherLessionsCell: UITableViewCell {

    @IBOutlet weak var lessionTypeOutlet: UILabel!
    @IBOutlet weak var sep1Outlet: UIView!
    @IBOutlet weak var timeOutlet: UILabel!
    @IBOutlet weak var contentOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: ClassListModel! {
        didSet {
            lessionTypeOutlet.text = model.typeText
            lessionTypeOutlet.backgroundColor = model.mainColor
            sep1Outlet.backgroundColor = model.mainColor
            contentOutlet.text = model.lesson_title
            timeOutlet.text = model.lesson_time
        }
    }
}
