//
//  ClassDetailVideoCell.swift
//  SpecialTraining
//
//  Created by yintao on 2019/6/12.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class ClassDetailVideoCell: UICollectionViewCell {

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
