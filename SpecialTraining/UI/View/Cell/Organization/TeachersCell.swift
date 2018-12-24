//
//  TeachersCell.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/23.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class TeachersCell: UICollectionViewCell {

    static let withoutImageHeight: CGFloat = 55
    
    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var introduceOutlet: UILabel!
    
    @IBOutlet weak var coverHeightCns: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model: TeachersModel! {
        didSet {
            coverOutlet.setImage(model.pic)
            nameOutlet.text = model.teacher_name
            introduceOutlet.text = model.introduce
            
            coverHeightCns.constant = model.imgHeight
        }
    }

}
