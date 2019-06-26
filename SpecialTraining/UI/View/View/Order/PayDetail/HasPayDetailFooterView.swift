//
//  HasPayDetailFooterView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/6/27.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class HasPayDetailFooterView: UICollectionReusableView {

    static let cellHight: CGFloat = 130.0

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var orderNumOutlet: UILabel!
    @IBOutlet weak var timeOutlet: UILabel!
    @IBOutlet weak var payBackOutlet: UIButton!
    
    public weak var delegate: HasPayDetailActions?
    
    @IBAction func payBackAction(_ sender: UIButton) {
        delegate?.payBack(model: model)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = (Bundle.main.loadNibNamed("HasPayDetailFooterView", owner: self, options: nil)?.first as! UICollectionReusableView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
        
        payBackOutlet.layer.cornerRadius = 4.0
        payBackOutlet.layer.borderWidth  = 1
        payBackOutlet.layer.borderColor  = RGB(60, 60, 60).cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: MemberAllOrderModel! {
        didSet {
            orderNumOutlet.text = model.order_number
            timeOutlet.text = model.createtime
        }
    }

}

protocol HasPayDetailActions: class {
    func payBack(model: MemberAllOrderModel)
}
