//
//  WaitForDealView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/2/24.
//  Copyright © 2019 youpeixun. All rights reserved.
//  等待商家处理

import UIKit

class WaitForDealView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var cancleOutlet: UIButton!
    @IBOutlet weak var editOutlet: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("WaitForDealView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        editOutlet.layer.cornerRadius = 4.0
        editOutlet.layer.borderWidth  = 1
        editOutlet.layer.borderColor  = RGB(212, 108, 52).cgColor
        
        cancleOutlet.layer.cornerRadius = 4.0
        cancleOutlet.layer.borderWidth  = 1
        cancleOutlet.layer.borderColor  = RGB(60, 60, 60).cgColor
        
        contentView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
