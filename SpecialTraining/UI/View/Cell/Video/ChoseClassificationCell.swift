//
//  ChoseClassificationCell.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/10.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class ChoseClassificationCell: UICollectionViewCell {

    private let selectedBgColor = ST_MAIN_COLOR_LIGHT
    private let unselectedBgColor = RGB(242, 242, 242)
    
    private let selectedTextColor = UIColor.white
    private let unselectedTextColor = RGB(60, 60, 60)
    
    @IBOutlet weak var titleOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setColor() {
        if model.isSelected == true {
            backgroundColor = selectedBgColor
            titleOutlet.textColor = selectedTextColor
        }else {
            backgroundColor = unselectedBgColor
            titleOutlet.textColor = unselectedTextColor
        }
    }
    
    var model: ChoseClassificationModel! {
        didSet {
            titleOutlet.text = model.name
            
            setColor()
        }
    }
    
    func refreshMark() {
        model.isSelected = !model.isSelected
        
        setColor()
    }

}
