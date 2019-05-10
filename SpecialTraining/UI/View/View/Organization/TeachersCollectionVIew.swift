//
//  TeachersCollectionVIew.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/23.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class TeachersCollectionVIew: UICollectionView {
    
    lazy var disposeBag: DisposeBag = { return DisposeBag() }()

    let datasource = Variable([ShopDetailTeacherModel]())
    let itemSelectedSubject = PublishSubject<ShopDetailTeacherModel>()
    
    private let layout = VideoFlowLayout()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        self.layout.interSpacing = 10
        self.layout.lineSpacing  = 10
        self.layout.edgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        super.init(frame: frame, collectionViewLayout: self.layout)
        
        setupUI()
        rxBind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        backgroundColor = .white
        showsVerticalScrollIndicator = false
        
        layout.delegate = self
        
        register(UINib.init(nibName: "TeachersCell", bundle: Bundle.main), forCellWithReuseIdentifier: "TeachersCellID")
    }
    
    private func rxBind() {
        
        datasource.asDriver()
            .drive(rx.items(cellIdentifier: "TeachersCellID", cellType: TeachersCell.self)) { (_, model, cell) in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        rx.modelSelected(ShopDetailTeacherModel.self)
            .asDriver()
            .drive(itemSelectedSubject)
            .disposed(by: disposeBag)
    }

}

extension TeachersCollectionVIew: FlowLayoutDelegate {
 
    func itemContent(layout: BaseFlowLayout, indexPath: IndexPath) -> CGSize {
        let model = datasource.value[indexPath.row]
        return .init(width: model.cellWidth, height: model.cellHeight)
    }
}
