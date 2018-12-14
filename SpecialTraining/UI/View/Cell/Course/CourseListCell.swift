//
//  CourseListCell.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//  eg：附近课程

import UIKit

let courseListCellID = "CourseListCellID"

let courseListCellHeight: CGFloat = 120.0

class CourseListCell: UICollectionViewCell {

    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var addressOutlet: UILabel!
    @IBOutlet weak var distanceOutlet: UILabel!
    @IBOutlet weak var desOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model: NearByCourseModel! {
        didSet {
//            coverOutlet.setImage(model.pic)
            titleOutlet.text = model.title
            addressOutlet.text = model.shop_name
            distanceOutlet.text = model.dis
            desOutlet.text = model.content
            priceOutlet.text = model.about_price
        }
    }

}
