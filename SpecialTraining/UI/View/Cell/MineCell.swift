//
//  MineCell.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/18.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class MineCell: UICollectionViewCell {

    @IBOutlet weak var imgOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model: MineModel! {
        didSet {
            imgOutlet.image = model.image
            titleOutlet.text = model.title
        }
    }

}
