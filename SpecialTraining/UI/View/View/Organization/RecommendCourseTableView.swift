//
//  RecommendCourseTableView.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/23.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class RecommendCourseTableView: BaseTB {
    
    let datasource = Variable([ShopCourseModel]())
    private let disposeBag = DisposeBag()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setupUI()
        rxBind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        showsVerticalScrollIndicator = false
        
        rowHeight = 175
        register(UINib.init(nibName: "OrganizationDetailCourseCell", bundle: Bundle.main),
                 forCellReuseIdentifier: "OrganizationDetailCourseCellID")
    }
    
    private func rxBind() {
        datasource.asDriver()
            .drive(rx.items(cellIdentifier: "OrganizationDetailCourseCellID", cellType: OrganizationDetailCourseCell.self)) { _, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
    }

}
