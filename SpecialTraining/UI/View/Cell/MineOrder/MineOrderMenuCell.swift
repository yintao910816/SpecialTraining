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
    @IBOutlet weak var lineLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lineLbl.backgroundColor = ST_MAIN_COLOR
    }
    
    var model: MineOrderMenuModel! {
        didSet {
            lblTitle.text = model.title
            if model.isSelected == true {
                lblTitle.textColor = ST_MAIN_COLOR
                lineLbl.isHidden = false
            }else {
                lblTitle.textColor = RGB(111, 111, 111)
                lineLbl.isHidden = true
            }
        }
    }
}
