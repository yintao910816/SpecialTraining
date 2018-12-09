//
//  VideoCoverChoseCell.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/9.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class VideoCoverChoseCell: UICollectionViewCell {

    @IBOutlet weak var coverOutlet: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var image: UIImage! {
        didSet {
            coverOutlet.image = image
        }
    }

}
