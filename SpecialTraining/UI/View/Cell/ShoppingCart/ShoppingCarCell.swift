//
//  ShoppingCarCell.swift
//  SpecialTraining
//
//  Created by yintao on 2019/1/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class ShoppingCarCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()

        clipsToBounds = true
    }

    var model: CourseClassModel! {
        didSet {
            if model.isLasstRow == true {
                set(cornerRadius: 6, borderCorners: [.bottomLeft, .bottomRight])
            }else {
                layer.mask = nil
            }
        }
    }
}
