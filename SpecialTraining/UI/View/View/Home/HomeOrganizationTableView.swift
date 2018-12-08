//
//  HomeOrganizationCollectionView.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HomeOrganizationTableView: BaseTB {

    private let disposeBag = DisposeBag()

    let datasource = Variable([OrganizationModel]())
    
    var tableHeader: OrganizationHeaderView!
    
    var cellSelected = PublishSubject<OrganizationModel>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .plain)
        
        setupUI()
        rxBind()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        if #available(iOS 11, *) {
            contentInsetAdjustmentBehavior = .never
        }

        showsVerticalScrollIndicator = false
        
        tableHeader = OrganizationHeaderView.init()
        tableHeaderView = tableHeader.contentView

        rowHeight = organizationCellHeight
        
        register(UINib.init(nibName: "OrganizationCell", bundle: Bundle.main), forCellReuseIdentifier: "OrganizationCellID")
    }
    
    private func rxBind() {
        
        datasource.asDriver()
            .drive(rx.items(cellIdentifier: "OrganizationCellID", cellType: OrganizationCell.self)) { [unowned self] row, model, cell in
                print("fasdfas")
            }
            .disposed(by: disposeBag)
        
        rx.modelSelected(OrganizationModel.self)
            .bind(to: cellSelected)
            .disposed(by: disposeBag)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = tableHeader.contentView.frame
        rect.size.width = width
        tableHeader.contentView.frame = rect
        
        tableHeader.contentView.height = tableHeader.actualHeight
    }

}
