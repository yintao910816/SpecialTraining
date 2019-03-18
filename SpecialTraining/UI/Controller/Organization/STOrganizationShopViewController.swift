//
//  STOrganizationShopViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/16.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STOrganizationShopViewController: BaseViewController {

    @IBOutlet weak var navheightCns: NSLayoutConstraint!
    @IBOutlet weak var tableView: PhysicalStoreTableView!
    @IBOutlet weak var carouseView: CarouselView!
    
    private var agnId: String = ""
    
    var viewModel: OrganizationShopViewModel!
    
    override func viewWillAppear(_ animated: Bool) {        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }

        navheightCns.constant += LayoutSize.fitTopArea
    }
    
    override func rxBind() {
        viewModel = OrganizationShopViewModel(agnId: agnId)
        
        viewModel.datasource.asDriver()
            .drive(tableView.datasource)
            .disposed(by: disposeBag)
        
        viewModel.advDatasource.asDriver()
            .drive(onNext: { [weak self] data in
                self?.carouseView.setData(source: data)
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func prepare(parameters: [String : Any]?) {
        agnId = parameters!["agn_id"] as! String
    }
}
