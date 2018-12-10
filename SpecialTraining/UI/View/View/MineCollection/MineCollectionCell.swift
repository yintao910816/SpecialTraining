//
//  MineCollectionCell.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/7.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit

class MineCollectionCell: BaseTBCell {

    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTag: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var model:MineCollectionModel! {
        didSet {
            imageV.image = UIImage(named: model.image)
            lblTitle.text = model.title
            lblTag.text = model.tag
            lblTime.text = model.time
        }
    }
    
}
