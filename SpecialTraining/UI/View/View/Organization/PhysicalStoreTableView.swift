//
//  PhysicalStoreTableView.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/23.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class PhysicalStoreTableView: BaseTB {

    var datasource = Variable([AgnDetailShopListModel]())
    
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
        rowHeight = 200
        
        register(UINib.init(nibName: "OrganizationDetailShopCell", bundle: Bundle.main),
                 forCellReuseIdentifier: "OrganizationDetailShopCellID")
    }
    
    private func rxBind() {
        datasource.asDriver()
            .drive(rx.items(cellIdentifier: "OrganizationDetailShopCellID", cellType: OrganizationDetailShopCell.self)){ _, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
    }

}
