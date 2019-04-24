





//
//  HomeCourseCell.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/30.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class HomeCourseCell: UICollectionViewCell {

    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var addressOutlet: UILabel!
    @IBOutlet weak var secondTitleTopCns: NSLayoutConstraint!
    @IBOutlet weak var setLineOutlet: UIView!
    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var priceOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: HomeNearbyCourseItemModel! {
        didSet {
            coverOutlet.isHidden = !model.showCellImg
            priceOutlet.text = "¥:\(model.about_price)"
            if model.showCellImg {
                coverOutlet.setImage(model.shop_logo)
                titleOutlet.text = model.shop_name
                addressOutlet.text = model.dis
                setLineOutlet.backgroundColor = RGB(240, 202, 162)
            }else {
                titleOutlet.text = nil
                addressOutlet.text = nil
                setLineOutlet.backgroundColor = RGB(255, 249, 242)
            }
        }
    }
}
