//
//  STMyScoreViewController.swift
//  SpecialTraining
//
//  Created by sw on 12/12/2018.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STMyScoreViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MyScoreViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        tableView.rowHeight = 65
        tableView.register(UINib.init(nibName: "MyScoreCell", bundle: Bundle.main), forCellReuseIdentifier: "MyScoreCellID")
    }
    
    override func rxBind() {
        viewModel = MyScoreViewModel()
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "MyScoreCellID", cellType: MyScoreCell.self)) { (_, model, cell) in
                
            }
            .disposed(by: disposeBag)
    }
    
}
