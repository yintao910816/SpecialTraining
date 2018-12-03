//
//  MineCustomCollectionReusableHeaderView.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/3.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit

class MineCustomCollectionReusableHeaderView: UICollectionReusableView {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    weak var delegate: MineSectionHeaderAction?
    
    @IBAction func clickAddBtn() {
        
        delegate?.addBtnClick()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var titleString:String! {
        didSet{
            title.text = titleString
        }
    }
}

protocol MineSectionHeaderAction: class {
    func addBtnClick()
}
