//
//  NeedPayDetailFooterView.swift
//  SpecialTraining
//
//  Created by sw on 26/06/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class NeedPayDetailFooterView: UICollectionReusableView {

    static let cellHight: CGFloat = 120.0
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var payOutlet: UIButton!
    @IBOutlet weak var canclePayOutlet: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = (Bundle.main.loadNibNamed("NeedPayDetailFooterView", owner: self, options: nil)?.first as! UICollectionReusableView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
        
        payOutlet.layer.cornerRadius = 4.0
        payOutlet.layer.borderWidth  = 1
        payOutlet.layer.borderColor  = RGB(212, 108, 52).cgColor
        
        canclePayOutlet.layer.cornerRadius = 4.0
        canclePayOutlet.layer.borderWidth  = 1
        canclePayOutlet.layer.borderColor  = RGB(60, 60, 60).cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
