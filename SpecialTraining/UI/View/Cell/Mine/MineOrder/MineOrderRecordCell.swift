//
//  MineOrderRecordCell.swift
//  SpecialTraining
//
//  Created by sw on 21/04/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class MineOrderRecordCell: UICollectionViewCell {

    static let contentHeight: CGFloat = 198.0
    
    @IBOutlet weak var shopNameOutlet: UIButton!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var detialOutlet: UILabel!
    @IBOutlet weak var remindOutlet: UILabel!
    @IBOutlet weak var rightOutlet: UIButton!
    @IBOutlet weak var leftOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model: MemberAllOrderModel! {
        didSet {
            shopNameOutlet.setTitle(model.shop_name, for: .normal)
            titleOutlet.text =
        }
    }

}
