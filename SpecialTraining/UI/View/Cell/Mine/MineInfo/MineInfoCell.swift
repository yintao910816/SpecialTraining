
//
//  MineInfoCell.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/19.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class MineInfoCell: BaseTBCell {

    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var detailTitleOutlet: UILabel!
    @IBOutlet weak var detailImageOutlet: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model: MineInfoModel! {
        didSet {
            titleOutlet.text = model.title
            detailTitleOutlet.text = model.detailTitle
            detailImageOutlet.image = model.detailImage
        }
    }
}
