//
//  STMineAddAccountViewController.swift
//  SpecialTraining
//
//  Created by xujun on 2018/12/21.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class STMineAddAccountViewController: BaseViewController {

    @IBOutlet weak var tableView: BaseTB!
    
    private var viewModel: MineAddAccountViewModel!
    
    override func setupUI() {
        title = "提现账户"
        
        tableView.rowHeight = 60
        tableView.register(UINib(nibName: "AddAccountCell", bundle: Bundle.main), forCellReuseIdentifier: "AddAccountCell")
        tableView.register(UINib(nibName: "SendCodeCell", bundle: Bundle.main), forCellReuseIdentifier: "SendCodeCell")
        tableView.register(UINib(nibName: "ConfirmBtnCell", bundle: Bundle.main), forCellReuseIdentifier: "ConfirmBtnCell")
    }
    
    override func rxBind() {
        viewModel = MineAddAccountViewModel()
        
//        let data = RxTableViewSectionedReloadDataSource<SectionModel<Int,MineAddAccountModel>>.init { (ds, tb, indexpath, model) -> UITableViewCell in
//            if indexpath.section == 1 {
//
//            } else {
//                if indexpath.row == 4 {
//
//                } else {
//
//                }
//            }
//
//            return UITableViewCell()
//        }
    }

}
