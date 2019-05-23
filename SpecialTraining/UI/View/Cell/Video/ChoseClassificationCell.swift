//
//  ChoseClassificationCell.swift
//  SpecialTraining
//
//  Created by yintao on 2019/2/20.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class ChoseClassificationCell: UITableViewCell {

    @IBOutlet weak var contentOutlet: UIButton!
    @IBOutlet weak var markOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model: ChoseClassificationModel! {
        didSet {
            contentOutlet.setTitle(model.item.cate_name, for: .normal)
            contentOutlet.isSelected = model.isSelected
            markOutlet.isHidden = !model.isSelected
        }
    }
    
    func refreshMark() {
        model.isSelected = !model.isSelected
        
        contentOutlet.isSelected = model.isSelected
        markOutlet.isHidden = !model.isSelected
    }
}
