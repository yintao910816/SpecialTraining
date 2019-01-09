//
//  SplendidnessContentTableView.swift
//  SpecialTraining
//
//  Created by yintao on 2018/12/14.
//  Copyright © 2018 youpeixun. All rights reserved.
//  课程详情 -- 精彩内容

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SplendidnessContentTableView: BaseTB {

    private let disposeBag = DisposeBag()
    
    let datasource = Variable([CourseDetailMediaModel]())
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .grouped)
        
        setupUI()
        rxBind()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {        
        backgroundColor = .white
        
        showsVerticalScrollIndicator = false
        
        rowHeight = 135
        
        register(UINib.init(nibName: "SplendidnessContentCell", bundle: Bundle.main), forCellReuseIdentifier: "SplendidnessContentCellID")
    }
    
    private func rxBind() {
        
        datasource.asDriver()
            .drive(rx.items(cellIdentifier: "SplendidnessContentCellID", cellType: SplendidnessContentCell.self)) { (row, model, cell) in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
    }
    
}
