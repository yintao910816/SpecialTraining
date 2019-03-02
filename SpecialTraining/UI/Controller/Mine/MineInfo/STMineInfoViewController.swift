//
//  STMineInfoViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/19.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class STMineInfoViewController: BaseViewController , VMNavigation{

    @IBOutlet weak var tableView: BaseTB!
    
    private var viewModel: MineInfoViewModel!
    
    override func setupUI() {
        title = "个人信息"
        
        let footerView = MineInfoAddStudentView.init(frame: .init(x: 0, y: 0, width: view.width, height: 121))
        tableView.tableFooterView = footerView
        footerView.addStudentCallBack = {
            PrintLog("添加学员")
        }
        
        tableView.register(UINib.init(nibName: "MineInfoCell", bundle: Bundle.main), forCellReuseIdentifier: "MineInfoCellID")
        tableView.register(UINib.init(nibName: "StudentInfoCell", bundle: Bundle.main), forCellReuseIdentifier: "StudentInfoCellID")
    }
    
    override func rxBind() {
        viewModel = MineInfoViewModel()
        
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<Int, MineInfoModelAdapt>>.init(configureCell: { (_, tb, indexPath, model) -> UITableViewCell in
            if indexPath.section == 0{
                let cell = tb.dequeueReusableCell(withIdentifier: "MineInfoCellID") as! MineInfoCell
                cell.model = (model as! MineInfoModel)
                return cell
            }
            let cell = tb.dequeueReusableCell(withIdentifier: "StudentInfoCellID") as! StudentInfoCell
            cell.model = (model as! StudentInfoModel)
            cell.changeStuentInfoCallBack = { [weak self] model in
                self?.performSegue(withIdentifier: "editStudentInfoSegue", sender: nil)
            }
            cell.deleteStudentCallBack = { model in
                
            }
            return cell
        })
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(MineInfoModel.self)
            .asDriver()
            .drive(onNext: { [unowned self] model in
                if model.title == "头像" {
                    self.performSegue(withIdentifier: "mineHeadIVSegue", sender: nil)
                }else if model.title == "昵称" {
                    
                }else if model.title == "我的二维码" {
                    self.performSegue(withIdentifier: "mineQRCodeSegue", sender: nil)
                }else if model.title == "常用地址" {
                    self.performSegue(withIdentifier: "myAddressSegue", sender: nil)
                }
            })
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
            let lable = UILabel()
            lable.textColor = ST_MAIN_COLOR
            lable.font = UIFont.systemFont(ofSize: 14)
            lable.backgroundColor = RGB(236, 235, 243)
            lable.text = "   学员信息"
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
            return 50
        default:
            return 0
        }
    }
}
