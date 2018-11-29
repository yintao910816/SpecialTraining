//
//  ShoppingListCell.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/17.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class ShoppingListCell: UITableViewCell {

    @IBOutlet weak var operationView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        operationView.layer.borderColor = GRAY_LIGHT_COLOR.cgColor
        operationView.layer.borderWidth = 1
    }
    
}
