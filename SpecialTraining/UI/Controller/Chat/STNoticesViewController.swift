//
//  STNoticesViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/15.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STNoticesViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: NoticesViewModel!
    
    override func setupUI() {
        tableView.rowHeight = 50
        tableView.register(UINib.init(nibName: "FriendsApplyCell", bundle: Bundle.main),
                           forCellReuseIdentifier: "FriendsApplyCellID")
    }
    
    override func rxBind() {
        viewModel = NoticesViewModel()
        
        viewModel.listDatasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "FriendsApplyCellID", cellType: FriendsApplyCell.self)) { [weak self] _, model, cell in
                guard let strongSelf = self else { return }
                cell.model = model
                cell.refuseOutlet.rx.tap.asDriver()
                    .map{ model }
                    .drive(strongSelf.viewModel.refuseSubject)
                    .disposed(by: strongSelf.disposeBag)
                
                cell.acceptOutlet.rx.tap.asDriver()
                    .map{ model }
                    .drive(strongSelf.viewModel.agreeSubject)
                    .disposed(by: strongSelf.disposeBag)
            }
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
}
