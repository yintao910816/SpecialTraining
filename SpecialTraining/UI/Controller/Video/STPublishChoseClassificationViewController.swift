//
//  STPublishChoseClassificationViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/10.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STPublishChoseClassificationViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ChoseClassificationViewModel!
    
    override func setupUI() {

        tableView.rowHeight = 45
        tableView.register(UINib.init(nibName: "ChoseClassificationCell", bundle: Bundle.main),
                           forCellReuseIdentifier: "ChoseClassificationCellID")
    }
    
    override func rxBind() {
        addBarItem(title: "确定").asDriver()
            .drive(onNext: { [weak self] in
                NotificationCenter.default.post(name: NotificationName.PublishVideo.ChooseClassifications,
                                                object: self?.viewModel.appendClassifications())
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel = ChoseClassificationViewModel()
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "ChoseClassificationCellID", cellType: ChoseClassificationCell.self)){ (_, model, cell) in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.asDriver()
            .drive(onNext: { [unowned self] indexPath in
                let cell = self.tableView.cellForRow(at: indexPath) as! ChoseClassificationCell
                cell.refreshMark()
            })
            .disposed(by: disposeBag)

    }
}
