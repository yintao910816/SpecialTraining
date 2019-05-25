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

    let datasource = Variable(([NearByOrganizationItemModel](), [AdvertListModel]()))
    
    private var carouseDatas = [AdvertListModel]()

    var tableHeader: OrganizationHeaderView!
    
    var cellSelected = PublishSubject<NearByOrganizationItemModel>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .grouped)
        
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

        backgroundColor = .white
        
        showsVerticalScrollIndicator = false
        
        tableHeader = OrganizationHeaderView.init()
        tableHeaderView = UIView.init(frame: .init(x: 0, y: 0, width: 0, height: 0.01))
        tableFooterView = UIView.init(frame: .init(x: 0, y: 0, width: 0, height: 0.01))

        rowHeight = organizationCellHeight
        
        register(UINib.init(nibName: "OrganizationCell", bundle: Bundle.main), forCellReuseIdentifier: "OrganizationCellID")
    }
    
    private func rxBind() {
        
        datasource.asDriver()
            .map(({ [weak self] data -> [NearByOrganizationItemModel] in
//                self?.carouseDatas = data.1
//                self?.tableHeader.setData(source: data.1)
                return data.0
            }))
            .drive(rx.items(cellIdentifier: "OrganizationCellID", cellType: OrganizationCell.self)) { row, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        rx.modelSelected(NearByOrganizationItemModel.self)
            .bind(to: cellSelected)
            .disposed(by: disposeBag)

        rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
}

extension HomeOrganizationTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableHeader.actualHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}
