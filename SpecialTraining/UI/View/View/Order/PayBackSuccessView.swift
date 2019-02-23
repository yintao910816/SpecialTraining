//
//  PayBackSuccessView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/2/24.
//  Copyright © 2019 youpeixun. All rights reserved.
//  退款成功

import UIKit

class PayBackSuccessView: UIView {

    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("PayBackSuccessView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
    
        contentView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
