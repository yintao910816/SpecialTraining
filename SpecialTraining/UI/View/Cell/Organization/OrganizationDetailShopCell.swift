//
//  OrganizationDetailShopCell.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/14.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class OrganizationDetailShopCell: UITableViewCell {

    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var distanceOutlet: UILabel!
    @IBOutlet weak var addressOutlet: UILabel!
    @IBOutlet weak var detailAddressOutlet: UILabel!
    @IBOutlet weak var infoOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: AgnDetailShopListModel! {
        didSet {
            titleOutlet.text = model.shop_name
            distanceOutlet.text = model.check_truth
            addressOutlet.text = model.address
            detailAddressOutlet.text = model.content
            infoOutlet.text = model.agn_description
            
            let lables = model.label.components(separatedBy: " ")
            for idx in 0..<lables.count {
                if idx < 3 {
                    let lable = contentView.viewWithTag(200 + idx) as? UILabel
                    lable?.text = "  \(lables[idx])  "
                }
            }
        }
    }
}
