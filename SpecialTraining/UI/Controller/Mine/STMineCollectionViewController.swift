//
//  STMineCollectionViewController.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/7.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class STMineCollectionViewController: BaseViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: BaseTB!
    var viewModel: MineCollectionViewModel!
    
    override func setupUI() {
        title = "收藏"
        addBarItem(normal: "", title: "按钮", right: true).drive(onNext: { [unowned self] (_) in
            PrintLog("点击右上角加号按钮")
        }).disposed(by: disposeBag)
        
        tableView.rowHeight = 120
        tableView.register(UINib(nibName: "MineCollectionCell", bundle: Bundle.main), forCellReuseIdentifier: "MineCollectionCell")
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.sectionInset = .init(top: 15, left: 0, bottom: 0, right: 0)
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.minimumLineSpacing      = 0
        flowlayout.itemSize = .init(width: (PPScreenW - 20)/4.0, height: 40)
        collectionView.collectionViewLayout = flowlayout
        
        collectionView.register(UINib(nibName: "MineHeaderCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MineHeaderCollectionCell")
    }
    
    override func rxBind() {
        viewModel = MineCollectionViewModel(keyword: searchTextField.rx.text.orEmpty.asDriver())
        
        viewModel.tableDatasource.asObservable().bind(to: tableView.rx.items(cellIdentifier: "MineCollectionCell", cellType: MineCollectionCell.self)) {
            (row, item, cell) in
            PrintLog(row)
        }.disposed(by: disposeBag)
        
        viewModel.colDatasource.asObservable().bind(to: collectionView.rx.items(cellIdentifier: "MineHeaderCollectionCell", cellType: MineHeaderCollectionCell.self)) {
            (row, item, cell) in
            if (row + 1) % 4 == 0 {
                cell.line.isHidden = true
            }
            cell.model = item
            }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(MineCollectionHeaderModel.self)
        .asDriver()
        .drive(viewModel.colSubject)
        .disposed(by: disposeBag)
    }

}
