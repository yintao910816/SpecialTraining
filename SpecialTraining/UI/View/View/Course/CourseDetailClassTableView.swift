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
    ///
    public let animotionHeaderSubject = PublishSubject<CGFloat>()
    /// 可以滚动header的最小contentSize高度
//    public var scrollMinContentHeight: CGFloat = 0
    
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
        bounces = false
        
        rowHeight = 75
        
        let header = UIView.init(frame: .init(x: 0, y: 0, width: PPScreenW, height: PPScreenW + 145 + 7 + 29 + 7 + 10))
        header.isUserInteractionEnabled = false
        tableHeaderView = header
        
        register(UINib.init(nibName: "CourseDetailClassCell", bundle: Bundle.main), forCellReuseIdentifier: "CourseDetailClassCellID")
    }
    
    private func rxBind() {
        
        datasource.asDriver()
            .drive(rx.items(cellIdentifier: "CourseDetailClassCellID", cellType: CourseDetailClassCell.self)) { (row, model, cell) in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
//        rx.didScroll.asDriver()
//            .drive(onNext: { [unowned self] in
//                PrintLog("最小contentSize高度 1111：\(self.scrollMinContentHeight)")
//
//                let point = self.panGestureRecognizer.translation(in: self)
//                if point.y > 0
//                {
//                    // 向下滚动
//                    if self.contentOffset.y < 44 { self.animotionHeaderSubject.onNext(false) }
//                }else {
//                    // 向上滚动
//                    if self.contentOffset.y > 0 && self.contentSize.height > self.scrollMinContentHeight { self.animotionHeaderSubject.onNext(true) }
//                }
//            })
//            .disposed(by: disposeBag)
        rx.didScroll.asDriver().map{ [unowned self] in self.contentOffset.y }
            .drive(animotionHeaderSubject)
            .disposed(by: disposeBag)

    }
    
}

extension CourseDetailClassTableView: AdaptScrollAnimotion {
    
    var scrollContentOffsetY: CGFloat { return contentOffset.y }

    func canAnimotion(offset y: CGFloat) -> Bool {
        return (contentSize.height - height) >= y
    }

    func scrollMax(contentOffset y: CGFloat) {
        if (contentSize.height - height) >= y {
            setContentOffset(.init(x: 0, y: y), animated: false)
        }else {
            setContentOffset(.init(x: 0, y: contentOffset.y), animated: true)
            animotionHeaderSubject.onNext(contentOffset.y)
        }
    }
}
