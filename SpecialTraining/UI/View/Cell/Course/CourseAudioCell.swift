




//
//  CourseAudioCell.swift
//  SpecialTraining
//
//  Created by yintao on 2018/12/17.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class CourseAudioCell: BaseTBCell {

    @IBOutlet weak var titleOutlet: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: CourseDetailAudioModel! {
        didSet {
            titleOutlet.text = model.res_title
        }
    }

}
