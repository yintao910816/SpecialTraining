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

class RecommendCourseView: UIView {
    
    private var carouselView: CarouselView!
    private var leadingView: UIView!
    private var titleLable: UILabel!
    private var courseListView: UITableView!
    private var headerView: UIView!

    let datasource = Variable([ShopDetailCourseModel]())
    let advDatasource = Variable([ShopDetailAdvModel]())
    
    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        rxBind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        carouselView = CarouselView.init(frame: .init(x: 0, y: 0, width: width, height: 140))
        
        leadingView = UIView()
        leadingView.backgroundColor = RGB(241, 85, 89)
        
        titleLable = UILabel()
        titleLable.textColor = RGB(56, 90, 116)
        titleLable.font = UIFont.systemFont(ofSize: 15)
        titleLable.text = "开设课程"
        
        headerView = UIView.init(frame: .init(x: 0, y: 0, width: width, height: 180))
        
        courseListView = UITableView.init(frame: .zero, style: .plain)
        courseListView.separatorStyle = .none
        courseListView.showsVerticalScrollIndicator = false
        courseListView.showsHorizontalScrollIndicator = false
        courseListView.rowHeight = 175
        courseListView.register(UINib.init(nibName: "OrganizationDetailCourseCell",
                                           bundle: Bundle.main),
                                forCellReuseIdentifier: "OrganizationDetailCourseCellID")
        courseListView.tableHeaderView = headerView

        headerView.addSubview(carouselView)
        headerView.addSubview(leadingView)
        headerView.addSubview(titleLable)
        
        addSubview(courseListView)
        
        carouselView.snp.makeConstraints{
            $0.left.top.right.equalTo(0)
            $0.height.equalTo(140)
        }
        
        leadingView.snp.makeConstraints{
            $0.left.equalTo(15)
            $0.top.equalTo(carouselView.snp.bottom).offset(10)
            $0.size.equalTo(CGSize.init(width: 6, height: 20))
        }
        
        titleLable.snp.makeConstraints{
            $0.left.equalTo(leadingView.snp.right).offset(3)
            $0.centerY.equalTo(leadingView.snp.centerY)
        }
        
        courseListView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    private func rxBind() {
        datasource.asDriver()
            .drive(courseListView.rx.items(cellIdentifier: "OrganizationDetailCourseCellID", cellType: OrganizationDetailCourseCell.self)) { _, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        advDatasource.asDriver()
            .drive(onNext: { [weak self] data in
                self?.carouselView.setData(source: data)
            })
            .disposed(by: disposeBag)
    }

}
