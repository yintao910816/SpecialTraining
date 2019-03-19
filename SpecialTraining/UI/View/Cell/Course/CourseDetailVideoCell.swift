//
//  CourseDetailVideoCell.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/20.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class CourseDetailVideoCell: UICollectionViewCell {

    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: CourseDetailVideoModel! {
        didSet {
            coverOutlet.setImage(model.res_image)
            titleOutlet.text = model.res_title
        }
    }
}
