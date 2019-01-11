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
    
    weak var delegate: ShoppingCarCellActions?
    
    @IBAction func actions(_ sender: UIButton) {
        switch sender.tag {
        case 200:
            // 选择
            sender.isSelected = !sender.isSelected
            model.isSelected = !model.isSelected
            
            delegate?.selecte(model: model)
        case 201:
            // 删除
            delegate?.delShop(model: model)
        case 202:
            // -
            setCount(isAdd: false)
        case 203:
            // +
            setCount(isAdd: true)
        default:
            break
        }
    }
    
    private func setCount(isAdd: Bool) {
        if isAdd == true {
            model.count += 1
        }else {
            model.count = model.count == 1 ? 1 : model.count - 1
        }
        countOutlet.text = "\(model.count)"
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
            countOutlet.text = "\(model.count)"
            choseOutlet.isSelected = model.isSelected
            if model.isLasstRow == true {
                set(cornerRadius: 6, borderCorners: [.bottomLeft, .bottomRight])
            }else {
                layer.mask = nil
            }
        }
    }
}

protocol ShoppingCarCellActions: class {
    
    func delShop(model: CourseClassModel)
    
    func selecte(model: CourseClassModel)
}
