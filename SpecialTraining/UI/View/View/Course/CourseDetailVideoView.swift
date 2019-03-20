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
    
    public let datasource = Variable([CourseDetailVideoModel]())
    public let itemDidSelected = PublishSubject<CourseDetailVideoModel>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        rxBind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
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
        addSubview(collectionView)
        
        collectionView.register(UINib.init(nibName: "CourseDetailVideoCell", bundle: Bundle.main),
                                forCellWithReuseIdentifier: "CourseDetailVideoCellID")
    }
    
    private func rxBind() {
        datasource.asDriver()
            .drive(collectionView.rx.items(cellIdentifier: "CourseDetailVideoCellID", cellType: CourseDetailVideoCell.self)) { _, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(CourseDetailVideoModel.self)
            .asDriver()
            .drive(itemDidSelected)
            .disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
}
