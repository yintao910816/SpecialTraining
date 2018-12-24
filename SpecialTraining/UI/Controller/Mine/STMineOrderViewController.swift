//
//  STMineOrderViewController.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/6.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class STMineOrderViewController: BaseViewController {

    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var tableView: BaseTB!
    var viewModel: MineOrderViewModel!
    
    override func setupUI() {
        title = "我的订单"
        addBarItem(normal: "", title:"按钮", right: true).drive(onNext: { [unowned self] (_) in
            PrintLog("点击右上角加号按钮")
        }).disposed(by: disposeBag)
        
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            menuCollectionView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing      = 0
        layout.itemSize = .init(width: PPScreenW/4.0, height: 60)
        menuCollectionView.collectionViewLayout = layout
        
        tableView.rowHeight = 120
        tableView.register(UINib(nibName: "MineCourseTableViewCell", bundle: nil), forCellReuseIdentifier: "MineCourseTableViewCell")
        menuCollectionView.register(UINib(nibName: "MineOrderMenuCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MineOrderMenuCell")
    }
    
    override func rxBind() {
        
        viewModel = MineOrderViewModel()
        
        viewModel.statusSource.asObservable().bind(to: menuCollectionView.rx.items(cellIdentifier: "MineOrderMenuCell", cellType: MineOrderMenuCell.self)) {
            (row,  item, cell) in
            cell.model = item
        }.disposed(by: disposeBag)
        
        viewModel.datasource.asObservable().bind(to: tableView.rx.items(cellIdentifier: "MineCourseTableViewCell", cellType: MineCourseTableViewCell.self)) { [unowned self] (row , item , cell) in
            cell.delegate = nil
            cell.delegate = self
            PrintLog(row)
            }.disposed(by: disposeBag)
        
        menuCollectionView.rx.modelSelected(MineOrderMenuModel.self)
            .asDriver()
            .drive(viewModel.statusChangeSubject)
            .disposed(by: disposeBag)
        
    }
}

extension STMineOrderViewController: MineCourseActions {
    
    func gotoLessonPrepare() {
        PrintLog("点击查看备课")
    }
    
    func gotoWaitingLesson() {
        PrintLog("点击待排课")
    }
    
}
