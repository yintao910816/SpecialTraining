//
//  MineChangeViewController.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/3.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class STMineChangeViewController: BaseViewController {
    
    @IBOutlet weak var tableView: BaseTB!
    @IBOutlet weak var moneyLbl: UILabel!
    var viewModel: MineChangeViewModel!
    
    override func setupUI() {
        title = "零钱"
        
        tableView.rowHeight = 85
        tableView.register(UINib(nibName: "MineChangeCell", bundle: nil), forCellReuseIdentifier: "MineChangeCell")
    }
    
    override func rxBind() {
        viewModel = MineChangeViewModel()
        
        viewModel.datasource.asObservable().bind(to:tableView.rx.items(cellIdentifier: "MineChangeCell", cellType: MineChangeCell.self)) {
            (row, item, cell) in
            PrintLog(row)
        }.disposed(by: disposeBag)
    }
    
    @IBAction func clickBtn(_ sender: UIButton) {
        switch sender.tag {
        case 1000:
            PrintLog("点击了提现")
        case 1001:
            PrintLog("点击了提现规则")
        default:
            break
        }
    }
}
