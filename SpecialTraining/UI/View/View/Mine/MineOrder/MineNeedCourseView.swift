//
//  MineNeedCourseView.swift
//  SpecialTraining
//
//  Created by sw on 25/01/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxSwift

class MineNeedCourseView: UICollectionView {
    
    let datasource = Variable([String]())
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let myLayout = UICollectionViewFlowLayout()
        myLayout.sectionInset = .init(top: 10, left: 10, bottom: 0, right: 10)
        myLayout.minimumLineSpacing = 10
        myLayout.itemSize = .init(width: PPScreenW - 10 - 10, height: 145)
        
        super.init(frame: frame, collectionViewLayout: myLayout)

        setupView()
        rxBind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = RGB(245, 245, 245)

        register(UINib.init(nibName: "MineNeedCourseOrderCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MineNeedCourseOrderCellID")
    }
    
    private func rxBind() {
        datasource.asDriver()
            .drive(rx.items(cellIdentifier: "MineNeedCourseOrderCellID", cellType: MineNeedCourseOrderCell.self)) {
                _, mode, cell in
            }
            .disposed(by: disposeBag)
        
    }
}
