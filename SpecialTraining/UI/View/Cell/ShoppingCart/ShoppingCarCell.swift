//
//  ShoppingCarCell.swift
//  SpecialTraining
//
//  Created by yintao on 2019/1/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class ShoppingCarCell: UICollectionViewCell {

    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var desOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var choseOutlet: UIButton!
    @IBOutlet weak var countOutlet: UILabel!
    @IBOutlet weak var decreaseOutlet: UIButton!
    @IBOutlet weak var addOutlet: UIButton!
    
    @IBAction func actions(_ sender: UIButton) {
        switch sender.tag {
        case 200:
            // 选择
            sender.isSelected = !sender.isSelected
            model.isSelected = !model.isSelected
        case 201:
            // 删除
            break
        case 202:
            // -
            break
        case 203:
            // +
            break
        default:
            break
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        clipsToBounds = true
    }

    var model: CourseClassModel! {
        didSet {
            coverOutlet.setImage(model.class_image)
            titleOutlet.text = model.class_name
            desOutlet.text = model.label
            priceOutlet.text = model.price
            if model.isLasstRow == true {
                set(cornerRadius: 6, borderCorners: [.bottomLeft, .bottomRight])
            }else {
                layer.mask = nil
            }
        }
    }
}

protocol CellActions {
    
    func delShop(model: CourseClassModel) 
}
