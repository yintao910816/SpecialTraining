//
//  CourseDisplayCell.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//  eg：体验专区

import UIKit

let courseDisplayCellID = "CourseDisplayCellID"

class CourseDisplayCell: UICollectionViewCell {

    @IBOutlet weak var coverOutlet: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    var model: ExperienceCourseItemModel! {
        didSet {
            coverOutlet.setImage(model.pic)
        }
    }
}
