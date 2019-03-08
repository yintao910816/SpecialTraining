//
//  MineAccountHeaderView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/7.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class MineAccountHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var bgViewHeightCns: NSLayoutConstraint!
    @IBOutlet weak var topCns: NSLayoutConstraint!
    
    public var backCallBack: (()->())?
    public var clickBalanceCallBack: (()->())?
    public var clickWithdrawCallBack: (() ->())?
    public var clickPayAccountCallBack: (() ->())?

    @IBAction func actions(_ sender: UIButton) {
        switch sender.tag {
        case 100:
            // 返回
            backCallBack?()
        case 101:
            // 零钱
            clickBalanceCallBack?()
        case 102:
            clickWithdrawCallBack?()
        case 103:
            clickPayAccountCallBack?()
        default:
            break
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("MineAccountHeaderView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }

        bgViewHeightCns.constant += LayoutSize.fitTopArea
        topCns.constant += LayoutSize.fitTopArea

        layoutIfNeeded()
        
        let frame = CGRect.init(x: 0, y: 0, width: bgView.width, height: bgView.height)
        bgView.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
