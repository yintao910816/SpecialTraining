//
//  PayBackSuccessView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/2/24.
//  Copyright © 2019 youpeixun. All rights reserved.
//  退款成功

import UIKit

class PayBackDetailHeaderView: UICollectionReusableView {
    
    static let contentHeight: CGFloat = 257

    @IBOutlet var contentView: UICollectionReusableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("PayBackDetailHeaderView", owner: self, options: nil)?.first as! UICollectionReusableView)
        addSubview(contentView)
    
        contentView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
