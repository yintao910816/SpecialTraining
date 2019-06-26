//
//  MineOrderHeaderReusableView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/4/22.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class MineOrderHeaderReusableView: UICollectionReusableView {
    
    static let contentHeight: CGFloat = 45.0
    
    @IBOutlet var contentView: UICollectionReusableView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var shopNameOutlet: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)     
        contentView = (Bundle.main.loadNibNamed("MineOrderHeaderReusableView", owner: self, options: nil)?.first as! UICollectionReusableView)
        addSubview(contentView)
//        bgView.set(cornerRadius: 8, borderCorners: [UIRectCorner.topLeft, UIRectCorner.topRight])
        
        contentView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
   
    }
    
    var model: MemberAllOrderModel! {
        didSet {
            shopNameOutlet.text = model.shop_name
        }
    }
        
}
