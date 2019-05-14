//
//  MyClassCell.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/15.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class MyClassCell: UITableViewCell {
    
    @IBOutlet weak var levelOutlet: UILabel!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var subTitleOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: MyClassModel! {
        didSet {
            levelOutlet.text = model.levelString
            titleOutlet.text = model.class_name
            subTitleOutlet.text = model.describe
        }
    }
}
