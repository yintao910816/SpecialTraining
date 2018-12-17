//
//  CourseSchoolTableView.swift
//  SpecialTraining
//
//  Created by yintao on 2018/12/17.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxSwift

class CourseSchoolTableView: BaseTB {
    
    private let disposeBag = DisposeBag()
    
    let datasource = Variable([String]())
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setupUI()
        rxBind()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        showsVerticalScrollIndicator = false
        
        rowHeight = 92
        
        register(UINib.init(nibName: "CourseSchoolCell", bundle: Bundle.main), forCellReuseIdentifier: "CourseSchoolCellID")
    }
    
    private func rxBind() {
        
        datasource.asDriver()
            .drive(rx.items(cellIdentifier: "CourseSchoolCellID", cellType: CourseSchoolCell.self)) { [unowned self] row, model, cell in
                
            }
            .disposed(by: disposeBag)
        
    }
    
}
