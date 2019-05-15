//
//  FriendsApplyCell.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/15.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class FriendsApplyCell: UITableViewCell {

    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var refuseOutlet: UIButton!
    @IBOutlet weak var acceptOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: AddFriendsModel! {
        didSet {
            titleOutlet.text = model.fromUser
        }
    }
}
