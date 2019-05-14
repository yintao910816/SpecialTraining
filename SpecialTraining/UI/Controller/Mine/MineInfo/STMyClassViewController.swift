
//
//  STMyClassViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/15.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxDataSources

class STMyClassViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    private var viewModel: MyClassViewModel!
    
    override func setupUI() {
        tableView.rowHeight = 60
        
        tableView.register(UINib.init(nibName: "MyClassCell", bundle: Bundle.main),
                           forCellReuseIdentifier: "MyClassCellID")
    }
    
    override func rxBind() {
        viewModel = MyClassViewModel()
        
        viewModel.listDataSource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "MyClassCellID", cellType: MyClassCell.self)) {
                _, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
}
