//
//  SplendidnessContentCell.swift
//  SpecialTraining
//
//  Created by yintao on 2018/12/14.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class SplendidnessContentCell: UITableViewCell {

    @IBOutlet weak var titleOutlet: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: CourseDetailMediaModel! {
        didSet {
            titleOutlet.text = model.res_title
        }
    }
}
