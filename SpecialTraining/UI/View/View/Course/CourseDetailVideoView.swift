//
//  CourseDetailVideoView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/20.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class CourseDetailVideoView: UIView {

    private var collectionView: UICollectionView!
    private let disposeBag = DisposeBag()
    
    public let datasource = Variable([SectionModel<Int, CourseDetailVideoModel>]())
    public let itemDidSelected = PublishSubject<CourseDetailVideoModel>()
   
    public let animotionHeaderSubject = PublishSubject<CGFloat>()
    /// 可以滚动header的最小contentSize高度
    public var scrollMinContentHeight: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        rxBind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 0, left: 7, bottom: 0, right: 7)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 7
        let w = (PPScreenW - layout.minimumInteritemSpacing - layout.sectionInset.left - layout.sectionInset.right) / 2.0
        let h = w * 4 / 3.0
        layout.itemSize = .init(width: w, height: h)
    
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        addSubview(collectionView)
        
        collectionView.register(UINib.init(nibName: "CourseDetailVideoCell", bundle: Bundle.main),
                                forCellWithReuseIdentifier: "CourseDetailVideoCellID")
        
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
    }
    
    private func rxBind() {
        let datasourceSignal = RxCollectionViewSectionedReloadDataSource<SectionModel<Int, CourseDetailVideoModel>>.init(configureCell: { (section, col, indexPath, model) -> UICollectionViewCell in
            let cell = col.dequeueReusableCell(withReuseIdentifier: "CourseDetailVideoCellID", for: indexPath) as! CourseDetailVideoCell
            cell.model = model
            return cell
        }, configureSupplementaryView: { (section, col, kind, indexpath) -> UICollectionReusableView in
            if kind == UICollectionView.elementKindSectionHeader {
                let header = col.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                  withReuseIdentifier: "header",
                                                                  for: indexpath)
                header.backgroundColor = .clear
                return header
            }
            return UICollectionReusableView()
            }, moveItem: { _,_,_  in
                
        }) { _,_  -> Bool in
            return false
        }

        datasource.asDriver()
            .drive(collectionView.rx.items(dataSource: datasourceSignal))
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(CourseDetailVideoModel.self)
            .asDriver()
            .drive(itemDidSelected)
            .disposed(by: disposeBag)
        
//        collectionView.rx.didScroll.asDriver()
//            .drive(onNext: { [unowned self] in
//                let point = self.collectionView.panGestureRecognizer.translation(in: self)
//                if point.y > 0
//                {
//                    // 向下滚动
//                    if self.collectionView.contentOffset.y < 44 { self.animotionHeaderSubject.onNext(false) }
//                }else {
//                    // 向上滚动
//                    if self.collectionView.contentOffset.y >= 0 && self.collectionView.contentSize.height > self.scrollMinContentHeight
//                    {
//                        self.animotionHeaderSubject.onNext(true)
//                    }
//                }
//            })
//            .disposed(by: disposeBag)
        
        collectionView.rx.didScroll.asDriver().map{ [unowned self] in self.collectionView.contentOffset.y }
            .drive(animotionHeaderSubject)
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
}

extension CourseDetailVideoView: AdaptScrollAnimotion {
    
    var scrollContentOffsetY: CGFloat { return collectionView.contentOffset.y }

    func canAnimotion(offset y: CGFloat) -> Bool {
        return collectionView.contentSize.height >= y
    }

    func scrollMax(contentOffset y: CGFloat) {
        if collectionView.contentSize.height >= y {
            collectionView.setContentOffset(.init(x: 0, y: y), animated: false)
        }else {
            collectionView.setContentOffset(.init(x: 0, y: collectionView.contentOffset.y), animated: true)
            animotionHeaderSubject.onNext(collectionView.contentOffset.y)
        }
    }
}

extension CourseDetailVideoView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height = PPScreenW + 145 + 7 + 29 + 7 + 10
        return .init(width: PPScreenW, height: height)
    }
}
