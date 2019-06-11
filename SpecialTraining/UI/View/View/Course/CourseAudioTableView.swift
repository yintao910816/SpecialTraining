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
    
    public let animotionHeaderSubject = PublishSubject<Bool>()
    /// 可以滚动header的最小contentSize高度
    public var scrollMinContentHeight: CGFloat = 0

    let datasource = Variable([CourseDetailAudioModel]())
    let itemDidSelected = PublishSubject<CourseDetailAudioModel>()
    
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
        
        rx.modelSelected(CourseDetailAudioModel.self)
            .bind(to: itemDidSelected)
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
                    if self.contentOffset.y > 0 && self.contentSize.height > self.scrollMinContentHeight { self.animotionHeaderSubject.onNext(true) }
                }
            })
            .disposed(by: disposeBag)
    }
    
}

extension CourseAudioTableView: AdaptScrollAnimotion {
    
    var canAnimotion: Bool { return contentSize.height > height }
    
}

