//
//  CourseDetailClassTableView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/20.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class CourseDetailClassTableView: UITableView {
    
    private let disposeBag = DisposeBag()
    
    let datasource = Variable([CourseDetailClassModel]())
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setupUI()
        rxBind()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        
        rowHeight = 75
        
        register(UINib.init(nibName: "CourseDetailClassCell", bundle: Bundle.main), forCellReuseIdentifier: "CourseDetailClassCellID")
    }
    
    private func rxBind() {
        
        datasource.asDriver()
            .drive(rx.items(cellIdentifier: "CourseDetailClassCellID", cellType: CourseDetailClassCell.self)) { (row, model, cell) in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
    }
    
}
