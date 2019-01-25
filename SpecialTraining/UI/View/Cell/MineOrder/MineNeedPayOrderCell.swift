//
//  MineNeedPayOrderCell.swift
//  SpecialTraining
//
//  Created by sw on 24/01/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class MineNeedPayOrderCell: UICollectionViewCell {

    @IBOutlet weak var shopOutlet: UIButton!
    @IBOutlet weak var coverOutlet: UIButton!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var desOutlet: UILabel!
    @IBOutlet weak var payOutlet: UIButton!
    @IBOutlet weak var canclePayOutlet: UIButton!
    
    weak var delegate: NeedPayOrderCellActions?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }
    
    @IBAction func actios(_ sender: UIButton) {
        switch sender.tag {
//        case 200:
//            // 取消
//        case 201:
//            // 支付
        default:
            break
        }
    }
    
    func setupView() {
        payOutlet.layer.cornerRadius = 4.0
        payOutlet.layer.borderWidth  = 1
        payOutlet.layer.borderColor  = RGB(212, 108, 52).cgColor
        
        canclePayOutlet.layer.cornerRadius = 4.0
        canclePayOutlet.layer.borderWidth  = 1
        canclePayOutlet.layer.borderColor  = RGB(60, 60, 60).cgColor
    }

}

protocol NeedPayOrderCellActions: class {
    
}

