//
//  MyEditAddressCell.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/3.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class MyEditAddressCell: UITableViewCell {

    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var inputOutlet: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: MyAddressModel! {
        didSet {
            titleOutlet.text = model.title
            inputOutlet.placeholder = model.placholdText
        }
    }
}
