//
//  STUseTipsViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/1.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxDataSources

class STUseTipsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: UseTipsViewModel!
    
    override func setupUI() {
        navigationItem.title = "使用技巧"
        
        tableView.rowHeight = 50
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
    
    override func rxBind() {
        viewModel = UseTipsViewModel()
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "cellID", cellType: UITableViewCell.self)) { _, model, cell in
                cell.textLabel?.text = model.title
                cell.selectionStyle = .none
                cell.accessoryType  = .disclosureIndicator
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asDriver()
            .drive(viewModel.cellDidSelected)
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
}

extension STUseTipsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lable = UILabel()
        lable.textColor = RGB(220, 220, 220)
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.text = "   使用技巧"
        return lable
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
