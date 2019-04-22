//
//  MineNeedPayOrderView.swift
//  SpecialTraining
//
//  Created by sw on 24/01/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class MineOrderView: UICollectionView {

    weak var aDelegate: UserOperation?
    
    let orderDatasource = Variable([SectionModel<MemberAllOrderModel, OrderItemModel>]())
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let myLayout = UICollectionViewFlowLayout()
        myLayout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        myLayout.minimumInteritemSpacing = 10
        
        super.init(frame: frame, collectionViewLayout: myLayout)
        
        setupView()
        rxBind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = RGB(250, 248, 249)
        
        register(UINib.init(nibName: "MineOrderHeaderReusableView", bundle: Bundle.main),
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: "header")
        register(MineOrderHeaderReusableView.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: "header")
        register(UINib.init(nibName: "MineOrderRecordCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MineOrderRecordCellID")
    }
    
    private func rxBind() {
        let datasource = RxCollectionViewSectionedReloadDataSource<SectionModel<MemberAllOrderModel, OrderItemModel>>.init(configureCell: { [weak self] (section, col, indexPath, model) -> UICollectionViewCell in
            let cell = col.dequeueReusableCell(withReuseIdentifier: "MineOrderRecordCellID", for: indexPath) as! MineOrderRecordCell
            cell.shopModel = section.sectionModels[indexPath.section].model
            cell.orderModel = model
            cell.delegate = nil
            cell.delegate = self
            return cell
        }, configureSupplementaryView: { (section, col, kind, indexpath) -> UICollectionReusableView in
            if kind == UICollectionView.elementKindSectionHeader {
                let header = col.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                  withReuseIdentifier: "header",
                                                                  for: indexpath) as! MineOrderHeaderReusableView
                header.model = section.sectionModels[indexpath.section].model
                return header
            }
            return UICollectionReusableView()
        }, moveItem: { _,_,_  in
            
        }) { _,_  -> Bool in
            return false
        }

        orderDatasource.asDriver()
            .drive(rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension MineOrderView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: width, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: width - 20, height: MineOrderRecordCell.contentHeight)
    }
}

extension MineOrderView: MineOrderRecordOperation {
    
    func orderOperation(statu: OrderStatu, orderNum: String) {
        aDelegate?.orderOperation(statu: statu, orderNum: orderNum)
    }
}

protocol UserOperation: class {
    func orderOperation(statu: OrderStatu, orderNum: String)
}
