
//
//  MyAddressCell.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/3.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class MyAddressCell: UITableViewCell {

    @IBOutlet weak var titleOutlet: UILabel!
    
    public var editCallBack: ((MyAddressModel) ->())?

    var model: MyAddressModel! {
        didSet {
            titleOutlet.text = model.address
        }
    }
    
    @IBAction func actions(_ sender: UIButton) {
        editCallBack?(model)
    }

}
