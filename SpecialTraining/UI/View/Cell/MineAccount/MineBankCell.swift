//
//  MineBankCell.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/4.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit

class MineBankCell: BaseTBCell {

    @IBOutlet weak var ivBg: UIImageView!
    @IBOutlet weak var ivBank: UIImageView!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var lblBankType: UILabel!
    @IBOutlet weak var lblBankNO: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
