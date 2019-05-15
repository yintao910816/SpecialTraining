//
//  NoticeAndApplyCell.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/15.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class NoticeAndApplyCell: UITableViewCell {

    @IBOutlet weak var cellIconOutlet: UIImageView!
    @IBOutlet weak var cellTitleOutlet: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model: ContactsModel! {
        didSet {
            cellIconOutlet.image = model.icon
            cellTitleOutlet.text = model.userName.count > 0 ? model.userName : model.title
        }
    }
}
