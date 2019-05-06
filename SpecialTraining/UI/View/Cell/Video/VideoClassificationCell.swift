//
//  VideoClassificationCell.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/17.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class VideoClassificationCell: UICollectionViewCell {

    @IBOutlet weak var titleOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    var model: VideoCateListModel! {
        didSet {
            titleOutlet.text = model.cate_name
            
            if model.isSelected == true {
                backgroundColor = ST_MAIN_COLOR
                titleOutlet.textColor = .white
            }else {
                backgroundColor = RGB(242, 242, 242)
                titleOutlet.textColor = RGB(111, 111, 111)
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = model.size.height / 2.0
    }
}
