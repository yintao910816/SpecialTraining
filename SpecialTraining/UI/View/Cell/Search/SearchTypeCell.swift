//
//  SearchTypeCell.swift
//  SpecialTraining
//
//  Created by yintao on 2019/2/25.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class SearchTypeCell: UITableViewCell {

    @IBOutlet weak var cellIconOutlet: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: SearchTypeModel! {
        didSet {
            cellIconOutlet.image = model.cellIcon
            cellTitle.attributedText = model.cellTitleArr
        }
    }
}
