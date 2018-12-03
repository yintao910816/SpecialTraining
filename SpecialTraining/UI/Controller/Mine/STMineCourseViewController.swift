//
//  STMineCourseViewController.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/11/30.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit
import RxSwift

class STMineCourseViewController: BaseViewController {
    
    @IBOutlet weak var tableView: BaseTB!
    var viewModel: MineCourseViewModel!
    
    override func setupUI() {
        title = "我的课程"
        
        tableView.rowHeight = 120
        tableView.register(UINib(nibName: "MineCourseTableViewCell", bundle: nil), forCellReuseIdentifier: "MineCourseTableViewCell")
    }
    
    override func rxBind() {
        viewModel = MineCourseViewModel()
        
        viewModel.datasource.asObservable().bind(to: tableView.rx.items(cellIdentifier: "MineCourseTableViewCell", cellType: MineCourseTableViewCell.self)) { (row , item , cell) in
            PrintLog(row)
        }.disposed(by: disposeBag)
        
    }

}
