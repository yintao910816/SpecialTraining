//
//  OrganizationCell.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

let organizationCellHeight: CGFloat = 114.0

class OrganizationCell: BaseTBCell {

    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var desOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        for idx in 100..<104 {
            let lable = contentView.viewWithTag(idx) as? UILabel
            lable?.layer.borderColor = RGB(37, 167, 250).cgColor
            lable?.layer.borderWidth = 1
        }
    }

    var model: NearByOrganizationItemModel! {
        didSet {
            coverOutlet.setImage(model.logo)
            titleOutlet.text = model.agn_name
            
            let lables = model.label.components(separatedBy: " ").filter{ $0.count > 0 }
            for idx in 0..<4 {
                let lable = contentView.viewWithTag(100 + idx) as? UILabel

                if idx < 4 && idx < lables.count {
                    lable?.text = "  \(lables[idx])  "
                }else {
                    lable?.text = nil
                }
            }
        }
    }
    
}
