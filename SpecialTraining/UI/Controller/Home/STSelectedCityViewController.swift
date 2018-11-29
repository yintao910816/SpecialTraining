//
//  STSelectedCityViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/22.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxDataSources

class STSelectedCityViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: SelectedCityViewModel!
    
    override func setupUI() {
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }

        tableView.rowHeight = 45
        tableView.sectionHeaderHeight = 30
        
        tableView.register(UINib.init(nibName: "CityCell", bundle: Bundle.main), forCellReuseIdentifier: "CityCellID")
    }
    
    override func rxBind() {
        viewModel = SelectedCityViewModel()
        
        let dataSignal = RxTableViewSectionedReloadDataSource<SectionModel<Int, CityModel>>.init(configureCell: { (_, tb, indexPath, model) -> UITableViewCell in
            let cell = tb.dequeueReusableCell(withIdentifier: "CityCellID") as! CityCell
            cell.model = model
            return cell
        }, titleForHeaderInSection: { (_, section) -> String? in
            return self.viewModel.sectionIndexTitles[section]
        }, titleForFooterInSection: { (_, section) -> String? in
            return nil
        }, canEditRowAtIndexPath: { (_, indexPath) -> Bool in
            return false
        }, canMoveRowAtIndexPath: { (_, indexPath) -> Bool in
            return false
        }, sectionIndexTitles: { [weak self] _ -> [String]? in
            return self?.viewModel.sectionIndexTitles
        }) { (_, text, section) -> Int in
            return section
        }
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(dataSource: dataSignal))
            .disposed(by: disposeBag)
    }
}

extension STSelectedCityViewController: UITableViewDelegate {
    
    
}
