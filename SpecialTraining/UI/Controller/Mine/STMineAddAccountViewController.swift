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
        
        let data = RxTableViewSectionedReloadDataSource<SectionModel<Int,MineAddAccountModel>>.init(configureCell: { (ds, tb, indexpath, model) -> UITableViewCell in
            
            if indexpath.section == 1 {
                let cell = tb.dequeueReusableCell(withIdentifier: "ConfirmBtnCell", for: indexpath) as! ConfirmBtnCell
                return cell
            } else if indexpath.section == 0 && indexpath.row == 4 {
                let cell = tb.dequeueReusableCell(withIdentifier: "SendCodeCell", for: indexpath) as! SendCodeCell
                return cell
            } else {
                let cell = tb.dequeueReusableCell(withIdentifier: "AddAccountCell", for: indexpath) as! AddAccountCell
                return cell
            }
            
        })
        
        viewModel.datasources.asDriver()
        .drive(tableView.rx.items(dataSource: data))
        .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }

}

extension STMineAddAccountViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        case 1:
            let view = UIView()
            view.backgroundColor = .clear
            return view
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 10
        default:
            return 0
        }
    }
    
}
