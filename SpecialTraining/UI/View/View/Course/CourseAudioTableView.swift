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
    
    public let animotionHeaderSubject = PublishSubject<CGFloat>()
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
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        bounces = false

        rowHeight = 60
        
        let header = UIView.init(frame: .init(x: 0, y: 0, width: PPScreenW, height: PPScreenW + 145 + 7 + 29 + 7 + 10))
        header.backgroundColor = .clear
        header.isUserInteractionEnabled = false
        tableHeaderView = header
        
        register(UINib.init(nibName: "CourseAudioCell", bundle: Bundle.main), forCellReuseIdentifier: "CourseAudioCellID")
        
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
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
        
//        rx.didScroll.asDriver()
//            .drive(onNext: { [unowned self] in
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

extension CourseAudioTableView: AdaptScrollAnimotion {
    
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

