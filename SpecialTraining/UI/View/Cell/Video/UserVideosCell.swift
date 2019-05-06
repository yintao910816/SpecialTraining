//
//  UserVideosCell.swift
//  SpecialTraining
//
//  Created by sw on 04/12/2018.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class UserVideosCell: UICollectionViewCell {

    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: MyVidesModel! {
        didSet {
            coverOutlet.setImage(model.cover_url)
            titleOutlet.text = model.title
        }
    }
}
