//
//  TeachersCell.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/23.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class TeachersCell: UICollectionViewCell {

    static let withoutImageHeight: CGFloat = 94
    
    @IBOutlet weak var coverHeightCns: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model: TeachersModel! {
        didSet {
            coverHeightCns.constant = model.imgHeight
        }
    }

}
