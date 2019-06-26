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
    @IBOutlet weak var returnStatuOutlet: UILabel!
    @IBOutlet weak var returnRemindOutlet: UILabel!
    @IBOutlet weak var returnAmountOutlet: UILabel!
    @IBOutlet weak var returnTypeAmountOutlet: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("PayBackDetailHeaderView", owner: self, options: nil)?.first as! UICollectionReusableView)
        addSubview(contentView)
    
        contentView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: RefundDetailsModel! {
        didSet {
            returnStatuOutlet.text = model.returnsStatusText
            returnRemindOutlet.text = model.returnsRemindText
            returnAmountOutlet.text = "¥: \(model.returns_amount)"
            returnTypeAmountOutlet.text = "¥: \(model.returns_amount)"
        }
    }
}
