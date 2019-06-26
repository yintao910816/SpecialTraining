//
//  PayBackDetailFooterView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/4/24.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class PayBackDetailFooterView: UICollectionReusableView {
    @IBOutlet var contentView: UICollectionReusableView!
    @IBOutlet weak var canclePayBackOutlet: UIButton!
    @IBOutlet weak var orderNumOutlet: UILabel!
    @IBOutlet weak var applyTimeOutlet: UILabel!
    @IBOutlet weak var returnNumOutlet: UILabel!
    @IBOutlet weak var returnAmountOutlet: UILabel!
    
    weak var delegate: PayBackDetailFooterOperation?

    @IBAction func actions(_ sender: UIButton) {
        delegate?.canclePayBack()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("PayBackDetailFooterView", owner: self, options: nil)?.first as! UICollectionReusableView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
        
        canclePayBackOutlet.setTitleColor(RGB(212, 108, 52), for: .normal)
        canclePayBackOutlet.layer.cornerRadius = canclePayBackOutlet.height / 2.0
        canclePayBackOutlet.layer.borderColor  = RGB(212, 108, 52).cgColor
        canclePayBackOutlet.layer.borderWidth  = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: RefundDetailsModel! {
        didSet {
            orderNumOutlet.text = "订单编号: \(model.order_number)"
            applyTimeOutlet.text = "申请时间: \(model.return_submit_time)"
            returnNumOutlet.text = "退款编号: \(model.returns_no)"
            returnAmountOutlet.text = "已退金额: ¥: \(model.returns_amount)"
        }
    }
}

protocol PayBackDetailFooterOperation: class {
    func canclePayBack()
}
