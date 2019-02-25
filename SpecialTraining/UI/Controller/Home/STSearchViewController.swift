//
//  STSearchViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/2/25.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class STSearchViewController: BaseViewController {
    
    private var viewModel: SearchViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTfOutlet: UITextField!
    
    @IBOutlet weak var navHeightCns: NSLayoutConstraint!
    
    @IBAction func actions(_ sender: UIButton) {
        switch sender.tag {
        case 100:
            navigationController?.popViewController(animated: true)
        case 101:
            PrintLog("取消")
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        navHeightCns.constant += LayoutSize.fitTopArea
        
        tableView.register(UINib.init(nibName: "SearchTypeCell", bundle: Bundle.main), forCellReuseIdentifier: "SearchTypeCellID")
    }

    override func rxBind() {
        viewModel = SearchViewModel.init(input: searchTfOutlet.rx.text.orEmpty.asDriver())
        
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<Int, SearchDataAdapt>>.init(configureCell: { [weak self] _, tb, indexPath, model  in
            if self?.viewModel.cellType == .searchType {
                let cell = tb.dequeueReusableCell(withIdentifier: "SearchTypeCellID") as! SearchTypeCell
                cell.model = (model as! SearchTypeModel)
                return cell
            }
            return UITableViewCell()
        })
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension STSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.cellType {
        case .searchType:
            return 50
        default:
            return 0
        }
    }
}
