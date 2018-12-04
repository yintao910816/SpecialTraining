//
//  UserVideosView.swift
//  SpecialTraining
//
//  Created by sw on 04/12/2018.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxSwift

class UserVideosView: UICollectionView {
    
    var datasource = Variable([UserVideosModel]())
    
    private let disposeBag = DisposeBag()

    private class var flowLayout: UICollectionViewFlowLayout {
        get {
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = .init(top: 10, left: 0, bottom: 0, right: 0)
            layout.minimumLineSpacing = 5
            layout.minimumInteritemSpacing = 5
            
            let w = (PPScreenW - layout.sectionInset.left - layout.sectionInset.right - 2 * layout.minimumInteritemSpacing) / 3.0
            let h = w * 4.0 / 3.0
            layout.itemSize = .init(width: w, height: h)
            return layout
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UserVideosView.flowLayout)
        
        backgroundColor = .white
        
        register(UINib.init(nibName: "UserVideosCell", bundle: Bundle.main), forCellWithReuseIdentifier: "UserVideosCellID")
        
        rxBind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func rxBind() {
        datasource.asDriver()
            .drive(rx.items(cellIdentifier: "UserVideosCellID", cellType: UserVideosCell.self)) { (_, model, cell) in

            }
            .disposed(by: disposeBag)
        
    }
}
