

//
//  ChoseOrganizationCell.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/10.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class ChoseOrganizationCell: UITableViewCell {

    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var markOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var model: ChoseOrganizationModel! {
        didSet {
            titleOutlet.text = model.name
            markOutlet.isSelected = model.isSelected
        }
    }
    
    func refreshMark() {
        model.isSelected = !model.isSelected
        markOutlet.isSelected = model.isSelected
    }
    
}
