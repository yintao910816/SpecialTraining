//
//  MineNeedClassOrderCell.swift
//  SpecialTraining
//
//  Created by sw on 24/01/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//  待上课

import UIKit

class MineNeedClassOrderCell: UICollectionViewCell {

    @IBOutlet weak var shopOutlet: UIButton!
    @IBOutlet weak var coverOutlet: UIButton!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var desOutlet: UILabel!
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func actions(_ sender: UIButton) {
    }
}
