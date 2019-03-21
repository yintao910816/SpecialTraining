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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: OrganazitonShopModel! {
        didSet {
            titleOutlet.text = model.shop_name
            distanceOutlet.text = model.dis
            addressOutlet.text = model.address
            
            for idx in 0..<3 {
                let lable = contentView.viewWithTag(200 + idx) as? UILabel
                lable?.text = nil
            }

            let lables = model.label.components(separatedBy: " ").filter{ $0.count > 0 }
            for idx in 0..<lables.count {
                if idx < 4 {
                    let lable = contentView.viewWithTag(200 + idx) as? UILabel
                    lable?.text = " \(lables[idx])  "
                    lable?.layer.borderColor = RGB(44, 188, 238).cgColor
                    lable?.layer.borderWidth = 1
                }
            }
            
            for idx in 0..<3 {
                let imgV = (contentView.viewWithTag(100 + idx) as! UIImageView)
                if idx < model.picList.count {
                    imgV.isHidden = false
                    imgV.setImage(model.picList[idx].shop_pic)
                }else {
                    imgV.isHidden = true
                }
            }
        }
    }
}
