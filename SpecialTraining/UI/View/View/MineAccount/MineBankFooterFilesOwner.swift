//
//  MineBankFooterFilesOwner.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/4.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit

class MineBankFooterFilesOwner: BaseFilesOwner {

    @IBOutlet var contentView: UIView!
    weak var delegate: MineBankAction?
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        delegate?.addBankCard()
    }
    
    override init() {
        super.init()
        contentView = (Bundle.main.loadNibNamed("MineBankFooterView", owner: self, options: nil)?.first as! UIView)
        contentView.layoutIfNeeded()
    }
}

protocol MineBankAction: class {
    func addBankCard()
}
