//
//  PhysicalStoreCell.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/23.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class PhysicalStoreCell: UITableViewCell {

    @IBOutlet weak var coverOutlet: UIButton!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var labelOutlet: UILabel!
    @IBOutlet weak var introduceOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model: PhysicalStoreModel! {
        didSet {
            coverOutlet.setImage(model.logo)
            nameOutlet.text = model.agn_name
            labelOutlet.text = model.label
            introduceOutlet.text = model.introduce
            
            for idx in 0..<3 {
                let btn = viewWithTag(500 + idx) as! UIButton
                if idx >= model.shops.count {
                    btn.isHidden = true
                }else {
                    btn.isHidden = false
                    btn.imageView?.contentMode = .scaleAspectFill
                    btn.setImage(model.shops[idx].logo)
                }
            }
        }
    }
    
}
