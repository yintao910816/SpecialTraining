//
//  STEditStudentInfoViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/3.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxDataSources

class STEditStudentInfoViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: EditStudentInfoViewModel!
    
    override func setupUI() {
        tableView.register(UINib.init(nibName: "MineInfoCell", bundle: Bundle.main), forCellReuseIdentifier: "MineInfoCellID")
        tableView.register(UINib.init(nibName: "StudentInfoCell", bundle: Bundle.main), forCellReuseIdentifier: "StudentInfoCellID")
    }

    override func rxBind() {
        viewModel = EditStudentInfoViewModel()
        
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<Int, MineInfoModel>>.init(configureCell: { (_, tb, indexPath, model) -> UITableViewCell in
            let cell = tb.dequeueReusableCell(withIdentifier: "MineInfoCellID") as! MineInfoCell
            cell.model = model
            return cell
        })
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)

    }
}

extension STEditStudentInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = viewModel.datasource.value[indexPath.section].items[indexPath.row]
        return model.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let lable = UILabel()
            lable.textColor = RGB(144, 144, 144)
            lable.font = UIFont.systemFont(ofSize: 14)
            lable.backgroundColor = .clear
            lable.text = "   请填写上课学员信息"
            return lable
        default:
            let view = UIView()
            view.backgroundColor = .clear
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 50 : 10
    }

}
