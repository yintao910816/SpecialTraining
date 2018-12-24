//
//  SendCodeCell.swift
//  SpecialTraining
//
//  Created by xujun on 2018/12/21.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class SendCodeCell: BaseTBCell {

    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 5
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = ST_MAIN_BG_SILVER_COLOR.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
