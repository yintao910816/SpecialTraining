//
//  STMineEditPayAccountViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxDataSources

class STMineEditPayAccountViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: MineEditPayAccountViewModel!
    
    override func setupUI() {
        tableView.register(UINib.init(nibName: "MineAddPayAccountCell", bundle: Bundle.main),
                           forCellReuseIdentifier: "MineAddPayAccountCellID")
        tableView.register(UINib.init(nibName: "MineEditPayAccountCell", bundle: Bundle.main),
                           forCellReuseIdentifier: "MineEditPayAccountCellID")
    }
    
    override func rxBind() {
        viewModel = MineEditPayAccountViewModel()
        
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<Int, String>>.init(configureCell: { _, tb, indexPath, model ->UITableViewCell in
            if indexPath.row == 2 {
                let cell = tb.dequeueReusableCell(withIdentifier: "MineAddPayAccountCellID") as! MineAddPayAccountCell
                return cell
            }
            let cell = tb.dequeueReusableCell(withIdentifier: "MineEditPayAccountCellID") as! MineEditPayAccountCell
            return cell
        })
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension STMineEditPayAccountViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 2 ? 120 : 140
    }
}
