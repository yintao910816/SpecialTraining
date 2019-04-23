//
//  PayBackDetailFooterView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/4/24.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class PayBackDetailFooterView: UICollectionReusableView {
    static let contentHeight: CGFloat = 107

    @IBOutlet var contentView: UICollectionReusableView!
    @IBOutlet weak var canclePayBackOutlet: UIButton!
    @IBOutlet weak var orderNumOutlet: UILabel!
    @IBOutlet weak var applyTimeOutlet: UILabel!
    
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
}

protocol PayBackDetailFooterOperation: class {
    func canclePayBack()
}
