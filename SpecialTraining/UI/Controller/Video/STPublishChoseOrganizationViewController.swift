//
//  STPublishChoseOrganizationViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/10.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STPublishChoseOrganizationViewController: BaseViewController {
    
    private var viewModel: PublishChoseOrganizationViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func actions(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func setupUI() {
        tableView.rowHeight = 45
        tableView.register(UINib.init(nibName: "ChoseOrganizationCell", bundle: Bundle.main), forCellReuseIdentifier: "CellID")
    }
    
    override func rxBind() {
        viewModel = PublishChoseOrganizationViewModel()
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "CellID", cellType: ChoseOrganizationCell.self)) { (_, model, cell) in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.asDriver()
            .drive(onNext: { [unowned self] indexPath in
                let cell = self.tableView.cellForRow(at: indexPath) as? ChoseOrganizationCell
                cell?.refreshMark()
            })
            .disposed(by: disposeBag)
    }
}

