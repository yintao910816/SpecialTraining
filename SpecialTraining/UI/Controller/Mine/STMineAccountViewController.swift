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
    @IBOutlet weak var tixianOutlet: UIButton!
    
    private var headerView: MineAccountHeaderView!
    
    private var viewModel: MineAccountViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }

        tableView.rowHeight = 65
        
        headerView = MineAccountHeaderView.init(frame: .init(x: 0, y: 0, width: view.width, height: 222 + LayoutSize.fitTopArea))
        tableView.tableHeaderView = headerView
        
        tableView.register(UINib.init(nibName: "MineAccountCell", bundle: Bundle.main), forCellReuseIdentifier: "MineAccountCellID")
        
        headerView.backCallBack = { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func rxBind() {
        viewModel = MineAccountViewModel()
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "MineAccountCellID", cellType: MineAccountCell.self)) { _, model, cell in
                
            }
            .disposed(by: disposeBag)

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
