//
//  RecommendCourseCell.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/23.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class RecommendCourseCell: UITableViewCell {

    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var contentOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var model: RecommendCourseModel! {
        didSet {
            coverOutlet.setImage(model.pic)
            titleOutlet.text = model.title
            contentOutlet.text = model.content
            priceOutlet.text   = model.about_price
        }
    }
}
