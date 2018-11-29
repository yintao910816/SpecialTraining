//
//  STMineInfoViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/19.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxDataSources

class STMineInfoViewController: BaseViewController {

    @IBOutlet weak var tableView: BaseTB!
    
    private var viewModel: MineInfoViewModel!
    
    override func setupUI() {
        title = "个人信息"
        
        tableView.register(UINib.init(nibName: "MineInfoCell", bundle: Bundle.main), forCellReuseIdentifier: "MineInfoCellID")
        tableView.register(UINib.init(nibName: "StudentInfoCell", bundle: Bundle.main), forCellReuseIdentifier: "StudentInfoCellID")
    }
    
    override func rxBind() {
        viewModel = MineInfoViewModel()
        
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<Int, MineInfoModelAdapt>>.init(configureCell: { (_, tb, indexPath, model) -> UITableViewCell in
            if indexPath.section == 0 || indexPath.section == 1 {
                let cell = tb.dequeueReusableCell(withIdentifier: "MineInfoCellID") as! MineInfoCell
                cell.model = (model as! MineInfoModel)
                return cell
            }
            let cell = tb.dequeueReusableCell(withIdentifier: "StudentInfoCellID") as! StudentInfoCell
            return cell
        })
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension STMineInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = viewModel.datasource.value[indexPath.section].items[indexPath.row]
        return model.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        case 1:
            let view = UIView()
            view.backgroundColor = .clear
            return view
        case 2:
            let lable = UILabel()
            lable.textColor = RGB(68, 68, 68)
            lable.font = UIFont.systemFont(ofSize: 16)
            lable.backgroundColor = .clear
            lable.text = "学员信息"
            lable.textAlignment = .center
            return lable
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
        case 2:
            return 45
        default:
            return 0
        }
    }
}
