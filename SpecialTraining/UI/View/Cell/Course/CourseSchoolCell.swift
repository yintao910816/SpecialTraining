

//
//  CourseSchoolCell.swift
//  SpecialTraining
//
//  Created by yintao on 2018/12/17.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class CourseSchoolCell: BaseTBCell {

    @IBOutlet weak var shopNameOutlet: UILabel!
    @IBOutlet weak var addressOutlet: UILabel!
    @IBOutlet weak var workTimeOutlet: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: RelateShopModel! {
        didSet {
            shopNameOutlet.text = model.shop_name
            addressOutlet.text = model.dis + "  " + model.address
            workTimeOutlet.text = model.work_time
        }
    }
}
