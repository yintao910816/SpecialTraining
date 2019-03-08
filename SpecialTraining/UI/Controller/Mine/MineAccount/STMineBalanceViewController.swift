//
//  STMineBalanceViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxDataSources

class STMineBalanceViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var headerView: MineBalanceHeaderView!
    
    private var viewModel: MineBalanceViewModel!
    
    override func viewWillAppear(_ animated: Bool) {        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }

        headerView = MineBalanceHeaderView.init(frame: .init(x: 0, y: 0, width: view.width, height: 230 + LayoutSize.fitTopArea))
        tableView.tableHeaderView = headerView
        
        headerView.clickBackCallBack = { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
        
        tableView.rowHeight = 65
        tableView.register(UINib.init(nibName: "MineAccountCell", bundle: Bundle.main), forCellReuseIdentifier: "MineAccountCellID")
    }
    
    override func rxBind() {
        viewModel = MineBalanceViewModel()
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "MineAccountCellID", cellType: MineAccountCell.self)) { _, model, cell in
                
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.asDriver()
            .drive(onNext: { [unowned self] _ in

            })
            .disposed(by: disposeBag)
    }
}
