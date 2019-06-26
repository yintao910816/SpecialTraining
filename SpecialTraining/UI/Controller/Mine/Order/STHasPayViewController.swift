//
//  STNeedForClassViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/2/24.
//  Copyright © 2019 youpeixun. All rights reserved.
//  已付款详情

import UIKit
import RxDataSources

class STHasPayViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var memberOrder: MemberAllOrderModel!
    private var viewModel: HasPayViewModel!
    
    override func setupUI() {
        view.backgroundColor = RGB(245, 245, 245)
        
        collectionView.register(MineOrderHeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        
        collectionView.register(HasPayDetailFooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: "footer")
        
        collectionView.register(UINib.init(nibName: "MineOrderRecordCell", bundle: Bundle.main),
                                forCellWithReuseIdentifier: "MineOrderRecordCellID")
    }
    
    override func rxBind() {
        viewModel = HasPayViewModel.init(memberOrder: memberOrder)
        
        let datasource = RxCollectionViewSectionedReloadDataSource<SectionModel<MemberAllOrderModel, OrderItemModel>>.init(configureCell: { (section, col, indexPath, model) -> UICollectionViewCell in
            let cell = col.dequeueReusableCell(withReuseIdentifier: "MineOrderRecordCellID", for: indexPath) as! MineOrderRecordCell
            cell.orderModel = model
            return cell
        }, configureSupplementaryView: { [weak self] (section, col, kind, indexpath) -> UICollectionReusableView in
            if kind == UICollectionView.elementKindSectionHeader {
                let header = col.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                  withReuseIdentifier: "header",
                                                                  for: indexpath) as! MineOrderHeaderReusableView
                header.model = section.sectionModels[indexpath.section].model
                return header
            }
            if kind == UICollectionView.elementKindSectionFooter {
                let footer = col.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                  withReuseIdentifier: "footer",
                                                                  for: indexpath) as! HasPayDetailFooterView
                footer.delegate = nil
                footer.delegate = self
                footer.model = section.sectionModels[indexpath.section].model
                return footer
            }
            return UICollectionReusableView()
        }, moveItem: { _,_,_  in
            
        }) { _,_  -> Bool in
            return false
        }
        
        viewModel.dataSource.asDriver()
            .drive(collectionView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        viewModel.reloadSubject.onNext(Void())
    }
    
    override func prepare(parameters: [String : Any]?) {
        memberOrder = (parameters!["model"] as! MemberAllOrderModel)
    }
    
}

extension STHasPayViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.width, height: MineOrderHeaderReusableView.contentHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: view.width, height: NeedPayDetailFooterView.cellHight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: view.width, height: MineOrderRecordCell.contentHeight)
    }
}

extension STHasPayViewController: HasPayDetailActions {
    func payBack(model: MemberAllOrderModel) {
        viewModel.payBackSubject.onNext(Void())
    }
}
