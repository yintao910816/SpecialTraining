//
//  BindPayAccountCell.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/10.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class BindPayAccountCell: UITableViewCell {

    @IBOutlet weak var iconOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: MineEditPayAccountModel! {
        didSet {
            iconOutlet.image = model.icon
            titleOutlet.text = model.title
        }
    }
}
