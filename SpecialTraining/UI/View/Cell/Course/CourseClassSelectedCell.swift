//
//  CourseClassSelectedCell.swift
//  SpecialTraining
//
//  Created by yintao on 2019/1/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class CourseClassSelectedCell: UICollectionViewCell {

    @IBOutlet weak var contentOutlet: UILabel!
    
    var model: CourseClassModel! {
        didSet {
            contentOutlet.text = "  \(model.teacher_name)  "
            setSelected()
        }
    }
    
    func setSelected() {
        if model.isSelected == true {
            contentOutlet.backgroundColor = ST_MAIN_COLOR_LIGHT
            contentOutlet.textColor       = .white
        }else {
            contentOutlet.backgroundColor = RGB(245, 245, 245)
            contentOutlet.textColor       = RGB(69, 69, 69)
        }
    }
    
}
