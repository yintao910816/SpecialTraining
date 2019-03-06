//
//  MineChangeCell.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/3.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit

class MineChangeCell: BaseTBCell {

    @IBOutlet weak var ivHead: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblReward: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblOrderNO: UILabel!
    @IBOutlet weak var lblOrderTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
