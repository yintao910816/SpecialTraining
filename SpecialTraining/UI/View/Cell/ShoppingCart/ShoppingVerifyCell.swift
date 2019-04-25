//
//  ShoppingVerifyCell.swift
//  SpecialTraining
//
//  Created by sw on 11/01/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class ShoppingVerifyCell: UICollectionViewCell {
    
    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var calssOutlet: UILabel!
    @IBOutlet weak var desOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: CourseDetailClassModel! {
        didSet {
            coverOutlet.setImage(model.pic)
            titleOutlet.text = model.title
            calssOutlet.text = " \(model.class_name)  "
            priceOutlet.text = "￥\(model.price)"
        }
    }
}
