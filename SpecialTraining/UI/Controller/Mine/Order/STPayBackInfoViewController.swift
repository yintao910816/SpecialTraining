//
//  STPayBackInfoViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/2/24.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxDataSources

class STPayBackInfoViewController: BaseViewController {
    
    private var viewModel: PayBackInfoViewModel!
    private var memberOrder: MemberAllOrderModel!

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var alertView: EditForBackAlertView!
    
    private lazy var waitForDealView: WaitForDealView = {
        let header = WaitForDealView.init(frame: .init(x: 0, y: 0, width: self.view.width, height: 615))
        return header
    }()
    
    override func setupUI() {
        navigationItem.title = "退款详情"
        view.backgroundColor = RGB(250, 250, 250)
        
        collectionView.register(PayBackDetailHeaderView.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: "header")
        collectionView.register(PayBackDetailFooterView.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                 withReuseIdentifier: "footer")
        
        collectionView.register(UINib.init(nibName: "MineOrderRecordCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MineOrderRecordCellID")

        alertView = EditForBackAlertView()
        view.addSubview(alertView)
        alertView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    override func rxBind() {
        viewModel = PayBackInfoViewModel.init(memberOrder: memberOrder)
        
        viewModel.detailInfoObser.asDriver()
            .drive(onNext: { [weak self] model in
                
            })
            .disposed(by: disposeBag)
        
        let datasource = RxCollectionViewSectionedReloadDataSource<SectionModel<Int, OrderItemModel>>.init(configureCell: { (section, col, indexPath, model) -> UICollectionViewCell in
            let cell = col.dequeueReusableCell(withReuseIdentifier: "MineOrderRecordCellID", for: indexPath) as! MineOrderRecordCell
            cell.orderModel = model
            return cell
            }, configureSupplementaryView: { (section, col, kind, indexpath) -> UICollectionReusableView in
                if kind == UICollectionView.elementKindSectionHeader {
                    let header = col.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                      withReuseIdentifier: "header",
                                                                      for: indexpath) as! PayBackDetailHeaderView
//                    header.model = section.sectionModels[indexpath.section].model
                    return header
                }
                if kind == UICollectionView.elementKindSectionFooter {
                    let footer = col.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                      withReuseIdentifier: "footer",
                                                                      for: indexpath) as! PayBackDetailFooterView
//                    footer.shopModel = section.sectionModels[indexpath.section].model
                    footer.delegate = nil
                    footer.delegate = self
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
        
        viewModel.popSubject
            .subscribe(onNext: { _ in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }

}

extension STPayBackInfoViewController {
    
    override func prepare(parameters: [String : Any]?) {
        memberOrder = (parameters!["model"] as! MemberAllOrderModel)
    }
}

extension STPayBackInfoViewController: PayBackDetailFooterOperation {
    
    func canclePayBack() {
        viewModel.canclePayBack.onNext(Void())
    }
}

extension STPayBackInfoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.width, height: PayBackDetailHeaderView.contentHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: view.width, height: PayBackDetailFooterView.contentHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: view.width, height: MineOrderRecordCell.contentHeight)
    }
}
