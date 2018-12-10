//
//  MineHeaderCollectionCell.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/7.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit

class MineHeaderCollectionCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var line: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model: MineCollectionHeaderModel! {
        didSet {
            lblTitle.text = model.title
        }
    }

}
