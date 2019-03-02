


//
//  STEditMyAddressViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/3.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STEditMyAddressViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: EditMyAddressViewModel!
    
    override func setupUI() {
        tableView.rowHeight = 50
        
        tableView.register(UINib.init(nibName: "MyEditAddressCell", bundle: Bundle.main),
                           forCellReuseIdentifier: "MyEditAddressCellID")
    }
    
    override func rxBind() {
        viewModel = EditMyAddressViewModel()
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "MyEditAddressCellID", cellType: MyEditAddressCell.self)) { _, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
    }
}
