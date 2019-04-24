//
//  CourseDisplayMinuteCell.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//  eg：为你优选

import UIKit

let courseDisplayMinuteCellID = "CourseDisplayMinuteCellID"
// 除开图片之外的高度
let courseDisplayMinuteCellBottomHeight: CGFloat = 52.0

class CourseDisplayMinuteCell: UICollectionViewCell {
    
    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var priceOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: ExperienceCourseItemModel! {
        didSet {
            coverOutlet.setImage(model.pic)
            priceOutlet.text = "¥:\(model.about_price)"
        }
    }    
}
