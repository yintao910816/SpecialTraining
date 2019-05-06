//
//  VideoCell.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/17.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class VideoCell: UICollectionViewCell {

    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: VideoListModel! {
        didSet {
            coverOutlet.setImage(model.cover_url)
            titleOutlet.text = model.title
        }
    }
}
