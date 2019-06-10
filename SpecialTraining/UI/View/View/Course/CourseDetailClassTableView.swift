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
    
    public let datasource = Variable([CourseDetailClassModel]())
    /// 参数为是否想上滚动
    public let animotionHeaderSubject = PublishSubject<Bool>()
    
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
        
        rx.didScroll.asDriver()
            .drive(onNext: { [unowned self] in
                let point = self.panGestureRecognizer.translation(in: self)
                if point.y > 0
                {
                    // 向下滚动
                    if self.contentOffset.y < 44 { self.animotionHeaderSubject.onNext(false) }
                }else {
                    // 向上滚动
                    if self.contentOffset.y > 0 { self.animotionHeaderSubject.onNext(true) }
                }
            })
            .disposed(by: disposeBag)
    }
    
}
