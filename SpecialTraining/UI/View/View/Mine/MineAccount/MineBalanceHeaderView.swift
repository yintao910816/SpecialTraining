//
//  MineBalanceHeaderView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class MineBalanceHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var topCns: NSLayoutConstraint!
   
    public var clickBackCallBack: (()->())?

    @IBAction func actions(_ sender: UIButton) {
        clickBackCallBack?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("MineBalanceHeaderView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
        
        topCns.constant += LayoutSize.fitTopArea
        
        layoutIfNeeded()
        
        let frame = CGRect.init(x: 0, y: 0, width: contentView.width, height: contentView.height)
        contentView.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
