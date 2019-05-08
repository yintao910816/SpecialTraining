//
//  STBalanceToFundsViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/10.
//  Copyright © 2019 youpeixun. All rights reserved.
//  零钱提现

import UIKit

class STBalanceToFundsViewController: BaseViewController {

    @IBOutlet weak var tixianAccountOutlet: UILabel!
    @IBOutlet weak var tixianCountOutlet: UILabel!
    @IBOutlet weak var serverChargeOutlet: UILabel!
    @IBOutlet weak var receiveCountOutlet: UILabel!
    
    @IBOutlet weak var applyFundsOutlet: UIButton!
    
    private var viewModel: BalanceToFundsViewModel!
    
    private var model: MineAccountModel!
    
    override func setupUI() {
        tixianAccountOutlet.text = "微信账户: \(UserAccountServer.share.loginUser.member.nickname)"
        tixianCountOutlet.text = "¥: \(model.can_commission)"
        receiveCountOutlet.text = "¥: \(model.can_commission)"
    }
    
    override func rxBind() {
        viewModel = BalanceToFundsViewModel.init(applyFunds: applyFundsOutlet.rx.tap.asDriver())
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] _ in self?.navigationController?.popToRootViewController(animated: true) })
            .disposed(by: disposeBag)
    }
    
    override func prepare(parameters: [String : Any]?) {
        model = (parameters!["model"] as! MineAccountModel)
    }
}
