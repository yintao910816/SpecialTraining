//
//  MineNeedCourseOrderCell.swift
//  SpecialTraining
//
//  Created by sw on 24/01/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class MineNeedCourseOrderCell: UICollectionViewCell {

    @IBOutlet weak var shopOutlet: UIButton!
    @IBOutlet weak var coverOutlet: UIButton!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var desOutlet: UILabel!
    @IBOutlet weak var canclePayOutlet: UIButton!

    @IBAction func canclePayAction(_ sender: UIButton) {
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        canclePayOutlet.layer.cornerRadius = 4.0
        canclePayOutlet.layer.borderWidth  = 1
        canclePayOutlet.layer.borderColor  = RGB(212, 108, 52).cgColor
    }

}
