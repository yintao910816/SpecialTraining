





//
//  HomeCourseCell.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/30.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class HomeCourseCell: UICollectionViewCell {

    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var addressOutlet: UILabel!
    @IBOutlet weak var secondTitleTopCns: NSLayoutConstraint!
    @IBOutlet weak var setLineOutlet: UIView!
    @IBOutlet weak var coverOutlet: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: TestCourseModel! {
        didSet {
            coverOutlet.isHidden = !model.showCellImg
            if model.showCellImg {
                titleOutlet.text = "引领右脑(公安青少年宫)"
                addressOutlet.text = "1.3km"
                setLineOutlet.backgroundColor = RGB(240, 202, 162)
            }else {
                titleOutlet.text = nil
                addressOutlet.text = nil
                setLineOutlet.backgroundColor = RGB(255, 249, 242)
            }
        }
    }
}
