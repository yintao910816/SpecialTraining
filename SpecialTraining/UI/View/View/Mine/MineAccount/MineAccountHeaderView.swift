//
//  MineAccountHeaderView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/7.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxSwift

class MineAccountHeaderView: UIView {

    private let disposeBag = DisposeBag()
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var bgViewHeightCns: NSLayoutConstraint!
    @IBOutlet weak var topCns: NSLayoutConstraint!
    
    @IBOutlet weak var totleAwardsOutlet: UILabel!
    @IBOutlet weak var canCommissionOutlet: UIButton!
    var totleAwardsObser = Variable("总奖金 ¥: 0")
    var canCommissionObser = Variable("可提现 ¥: 0")

    public var backCallBack: (()->())?
    public var clickBalanceCallBack: (()->())?
    public var clickWithdrawCallBack: (() ->())?
    public var clickPayAccountCallBack: (() ->())?
    // 提现规则
    public var clickWithdrawRuleCallBack: (() ->())?

    @IBAction func actions(_ sender: UIButton) {
        switch sender.tag {
        case 100:
            // 返回
            backCallBack?()
        case 101:
            // 零钱
//            clickBalanceCallBack?()
            break
        case 102:
            // 可提现
            clickWithdrawCallBack?()
        case 103:
//            clickPayAccountCallBack?()
            break
        case 104:
            // 提现规则
//            clickPayAccountCallBack?()
            clickWithdrawRuleCallBack?()
            break
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
        
        rxBind()
    }
    
    private func rxBind() {
        totleAwardsObser.asDriver()
            .drive(totleAwardsOutlet.rx.text)
            .disposed(by: disposeBag)
        
        canCommissionObser.asDriver()
            .drive(canCommissionOutlet.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
