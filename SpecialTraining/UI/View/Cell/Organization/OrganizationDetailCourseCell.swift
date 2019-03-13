
//
//  OrganizationDetailCourseCell.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/14.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class OrganizationDetailCourseCell: UITableViewCell {

    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var desOutlet: UILabel!
    @IBOutlet weak var classTimeOutlet: UIButton!
    
    public var clickTimeCallBack: ((AgnDetailCourseListModel) ->())?
    
    @IBAction func actions(_ sender: UIButton) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        classTimeOutlet.layer.cornerRadius = 5
        classTimeOutlet.layer.borderColor  = RGB(55, 177, 250).cgColor
        classTimeOutlet.layer.borderWidth  = 1
    }

    var model: AgnDetailCourseListModel! {
        didSet {
            coverOutlet.setImage(model.pic)
            titleOutlet.text = model.title
            desOutlet.text = model.content
            priceOutlet.text = model.about_price
            
            let lables = model.label.components(separatedBy: " ")
            for idx in 0..<lables.count {
                if idx < 3 {
                    let lable = contentView.viewWithTag(100 + idx) as? UILabel
                    lable?.text = "  \(lables[idx])  "
                }
            }
        }
    }
}
