//
//  STBindPayAccountViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/10.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxDataSources

class STBindPayAccountViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: BindPayAccountViewModel!
    
    override func setupUI() {
        tableView.rowHeight = 141
        
        tableView.register(UINib.init(nibName: "BindPayAccountCell", bundle: Bundle.main),
                           forCellReuseIdentifier: "BindPayAccountCellID")
    }
    
    override func rxBind() {
        viewModel = BindPayAccountViewModel()
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "BindPayAccountCellID", cellType: BindPayAccountCell.self)) { _, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
    }
}
