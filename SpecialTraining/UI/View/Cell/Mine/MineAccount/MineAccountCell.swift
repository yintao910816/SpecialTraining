//
//  MineAccountCell.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/7.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class MineAccountCell: UITableViewCell {

    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var timeOutlet: UILabel!
    @IBOutlet weak var countOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: MineAwardsModel! {
        didSet {
            titleOutlet.text = "\(model.mob.replacePhone()) 购买课程奖励发放"
            timeOutlet.text = model.createtime
        }
    }
}
