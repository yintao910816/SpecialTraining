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
        
        viewModel.datasource.asObservable().bind(to: tableView.rx.items(cellIdentifier: "MineCourseTableViewCell", cellType: MineCourseTableViewCell.self)) { [unowned self] (row , item , cell) in
            cell.delegate = nil
            cell.delegate = self
            PrintLog(row)
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected.asDriver()
            .drive(onNext: { [unowned self] _ in

            })
            .disposed(by: disposeBag)
        
    }

}

extension STMineCourseViewController: MineCourseActions {
    
    func gotoLessonPrepare() {
        PrintLog("点击查看备课")
    }
    
    func gotoWaitingLesson() {
        PrintLog("点击待排课")
    }
    
}
