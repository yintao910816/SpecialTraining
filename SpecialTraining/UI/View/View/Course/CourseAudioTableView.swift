//
//  CourseAudioTableView.swift
//  SpecialTraining
//
//  Created by yintao on 2018/12/17.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxSwift

class CourseAudioTableView: BaseTB {
    
    private let disposeBag = DisposeBag()
    
    let datasource = Variable([CourseDetailMediaModel]())
    
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
        
        rowHeight = 60
        
        register(UINib.init(nibName: "CourseAudioCell", bundle: Bundle.main), forCellReuseIdentifier: "CourseAudioCellID")
    }
    
    private func rxBind() {
        
        datasource.asDriver()
            .drive(rx.items(cellIdentifier: "CourseAudioCellID", cellType: CourseAudioCell.self)) { (row, model, cell) in
                cell.model = model
            }
            .disposed(by: disposeBag)
    }
    
}
