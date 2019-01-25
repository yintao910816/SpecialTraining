//
//  MineNeedPayOrderView.swift
//  SpecialTraining
//
//  Created by sw on 24/01/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class MineNeedPayOrderView: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumLineSpacing = 10
        layout.itemSize = .init(width: frame.width, height: 145)
        
        super.init(frame: frame, collectionViewLayout: layout)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
