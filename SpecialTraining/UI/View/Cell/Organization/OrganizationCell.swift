//
//  OrganizationCell.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

let organizationCellHeight: CGFloat = 156.0

class OrganizationCell: BaseTBCell {

    @IBOutlet weak var moreOutlet: UIButton!
    @IBOutlet weak var effectOutlet: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {

    }
    
}
