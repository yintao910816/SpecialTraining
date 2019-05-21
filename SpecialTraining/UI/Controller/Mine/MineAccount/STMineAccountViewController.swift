//
//  STMineAccountViewController.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/11/30.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class STMineAccountViewController: BaseViewController {
    
    @IBOutlet weak var tableView: BaseTB!
    
    private var headerView: MineAccountHeaderView!
    
    private var viewModel: MineAccountViewModel!
    
    @IBAction func actions(_ sender: UIButton) {
        if let model = viewModel.getAccountModel() {
            if (Double(model.can_commission) ?? 0) >= 1 {
                performSegue(withIdentifier: "balanceToFundsSegue", sender: model)
            }else {
                NoticesCenter.alert(title: "提示", message: "最小提现金额为1元")
            }
        }else {
            NoticesCenter.alert(title: "提示", message: "未获取到提现信息")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }

        tableView.rowHeight = 65
        
        headerView = MineAccountHeaderView.init(frame: .init(x: 0, y: 0, width: view.width, height: 218 + LayoutSize.fitTopArea))
        tableView.tableHeaderView = headerView
        
        tableView.register(UINib.init(nibName: "MineAccountCell", bundle: Bundle.main), forCellReuseIdentifier: "MineAccountCellID")
        
        headerView.backCallBack = { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
        
        headerView.clickWithdrawRuleCallBack = { [unowned self] in
            let message = "1、用户可提现金额大于1元。\n2、提现申请时间：随时。\n3、提现审核时间：每周一至周五9:00-17:00。\n4、到账时间：审核通过后及时到账。"
            NoticesCenter.alert(title: "提现规则", message: message, okTitle: "确定", isCustom: true, presentCtrl: self)
        }

//        headerView.clickBalanceCallBack = { [unowned self] in
//            self.performSegue(withIdentifier: "mineBalanceSegue", sender: nil)
//        }
//
//        headerView.clickWithdrawCallBack = { [unowned self] in
//            self.performSegue(withIdentifier: "withdrawSegue", sender: nil)
//        }
//
//        headerView.clickPayAccountCallBack = { [unowned self] in
//            self.performSegue(withIdentifier: "mineEditAccoutSegue", sender: nil)
//        }
    }
    
    override func rxBind() {
        viewModel = MineAccountViewModel()
        
        viewModel.totleAwardsObser.asDriver()
            .drive(headerView.totleAwardsObser)
            .disposed(by: disposeBag)
        
        viewModel.canCommissionObser.asDriver()
            .drive(headerView.canCommissionObser)
            .disposed(by: disposeBag)

        viewModel.listDatasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "MineAccountCellID", cellType: MineAccountCell.self)) { _, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(MineAwardsModel.self)
            .asDriver()
            .drive(onNext: { [unowned self] model in
                self.performSegue(withIdentifier: "accountDetailSegue", sender: model)
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "accountDetailSegue" {
            let model = (sender as! MineAwardsModel)
            segue.destination.prepare(parameters: ["item_id": model.item_id, "level": model.level])
        }else if segue.identifier == "balanceToFundsSegue" {
            let model = (sender as! MineAccountModel)
            segue.destination.prepare(parameters: ["model": model])
        }
    }
//    @IBAction func btnClick(_ sender: UIButton) {
//        let tag = sender.tag
//        switch tag {
//        case 1000:
//            PrintLog("点击了收付款")
//            performSegue(withIdentifier: "withdrawAccountSegue", sender: nil)
//        case 1001:
//            PrintLog("点击了零钱")
//            performSegue(withIdentifier: "changeSegue", sender: nil)
//        case 1002:
//            PrintLog("点击了银行卡")
//            performSegue(withIdentifier: "bankSegue", sender: nil)
//        default:
//            break
//        }
//    }
}
