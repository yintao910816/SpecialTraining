//
//  STMineBankViewController.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/4.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit
import RxSwift

class STMineBankViewController: BaseViewController {

    @IBOutlet weak var tableView: BaseTB!
    var viewModel: MineBankViewModel!
    var footerView: MineBankFooterFilesOwner!
    
    override func setupUI() {
        title = "银行卡"
        
        tableView.rowHeight = 110
        tableView.register(UINib(nibName: "MineBankCell", bundle: nil), forCellReuseIdentifier: "MineBankCell")
        footerView = MineBankFooterFilesOwner()
        footerView.delegate = self
        tableView.tableFooterView = footerView.contentView
    }
    
    override func rxBind() {
        viewModel = MineBankViewModel()
        
        viewModel.datasource.asObservable().bind(to:tableView.rx.items(cellIdentifier: "MineBankCell", cellType: MineBankCell.self)) {
            (row, item, cell) in
            PrintLog(row)
        }.disposed(by: disposeBag)
    }

}

extension STMineBankViewController: MineBankAction {
    
    func addBankCard() {
        PrintLog("添加银行卡")
    }
    
}
