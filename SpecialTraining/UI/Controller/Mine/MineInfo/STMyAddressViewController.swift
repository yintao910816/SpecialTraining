//
//  STMyAddressViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/3.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxDataSources

class STMyAddressViewController: BaseViewController {

    private var viewModel: MyAddressViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func setupUI() {
        tableView.rowHeight = 45
        
        tableView.register(UINib.init(nibName: "MyAddressCell", bundle: Bundle.main),
                           forCellReuseIdentifier: "MyAddressCellID")
    }
    
    override func rxBind() {
        viewModel = MyAddressViewModel()
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "MyAddressCellID", cellType: MyAddressCell.self)) { _, model, cell in
                cell.model = model
                cell.editCallBack = { [weak self] model in
                    self?.performSegue(withIdentifier: "editMyAddressSegue", sender: nil)
                }
            }
            .disposed(by: disposeBag)
    }
}
