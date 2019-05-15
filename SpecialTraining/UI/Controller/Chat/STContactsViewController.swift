//
//  STContactsViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/15.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STContactsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: ContactsViewModel!
    
    override func setupUI() {
        
        tableView.rowHeight = 50
        tableView.register(UINib.init(nibName: "NoticeAndApplyCell", bundle: Bundle.main),
                           forCellReuseIdentifier: "NoticeAndApplyCellID")
    }
    
    override func rxBind() {
        
        addBarItem(title: "添加")
            .drive(onNext: { [unowned self] in
                self.performSegue(withIdentifier: "addFriendsSegue", sender: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel = ContactsViewModel()
        
        viewModel.listDataSource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "NoticeAndApplyCellID", cellType: NoticeAndApplyCell.self)) { _, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ContactsModel.self)
            .asDriver()
            .drive(onNext: { model in
                
            })
            .disposed(by: disposeBag)
    }
}
