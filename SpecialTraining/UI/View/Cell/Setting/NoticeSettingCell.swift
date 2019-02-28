//
//  NoticeSettingCell.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/1.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class NoticeSettingCell: UITableViewCell {

    @IBOutlet weak var markOutlet: UIButton!
    @IBOutlet weak var titleOutlet: UILabel!

    var model: NoticeSettingModel! {
        didSet {
            markOutlet.isSelected = model.isSelected
            titleOutlet.text = model.title
        }
    }
    
}
