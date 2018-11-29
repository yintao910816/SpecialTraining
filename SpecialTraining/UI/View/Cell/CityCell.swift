//
//  CityCell.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/22.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {

    @IBOutlet weak var cityNameOutlet: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: CityModel! {
        didSet {
            cityNameOutlet.text = model.city
        }
    }
}
