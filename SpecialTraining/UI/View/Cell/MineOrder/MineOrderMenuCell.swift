//
//  MineOrderMenuCell.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/6.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit

class MineOrderMenuCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model: MineOrderMenuModel! {
        didSet {
            lblTitle.text = model.title
            if model.isSelected == true {
                lblTitle.textColor = ST_MAIN_COLOR
                lblTitle.font = UIFont.systemFont(ofSize: 15)
            }else {
                lblTitle.textColor = RGB(111, 111, 111)
                lblTitle.font = UIFont.systemFont(ofSize: 13)
            }
        }
    }
}
