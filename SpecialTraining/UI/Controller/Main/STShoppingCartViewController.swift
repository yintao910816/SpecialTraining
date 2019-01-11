//
//  STShoppingCartViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class STShoppingCartViewController: BaseViewController {

    @IBOutlet weak var bgColorView: UIView!
    @IBOutlet weak var titleTopCns: NSLayoutConstraint!
    @IBOutlet weak var bgColorHeightCNs: NSLayoutConstraint!
    @IBOutlet weak var jiesuanOutlet: UIButton!
    
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var allChoseOutlet: UIButton!
    @IBOutlet weak var allChoseZRemindOutlet: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel: ShoppingCartViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        
        if UIDevice.current.isX == true {
            titleTopCns.constant = titleTopCns.constant + 44
            bgColorHeightCNs.constant = bgColorHeightCNs.constant + 44
        }
        
        var frame = CGRect.init(x: 0, y: 0, width: PPScreenW, height: bgColorHeightCNs.constant)
        bgColorView.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
        
        frame = .init(x: 0, y: 0, width: 85, height: 45)
        jiesuanOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
        
        collectionView.register(UINib.init(nibName: "ShoppingCarCell", bundle: Bundle.main),
                                forCellWithReuseIdentifier: "ShoppingCarCellID")
        collectionView.register(ShopingCarTitleReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "ShopingCarTitleReusableViewID")
        
    }
    
    override func rxBind() {
        viewModel = ShoppingCartViewModel.init(tap: jiesuanOutlet.rx.tap.asDriver())

        let datasource = RxCollectionViewSectionedReloadDataSource<SectionModel<SectionCourseClassModel, CourseClassModel>>.init(configureCell: { (_, col, indexPath, model) -> UICollectionViewCell in
            let cell = col.dequeueReusableCell(withReuseIdentifier: "ShoppingCarCellID", for: indexPath) as! ShoppingCarCell
            cell.model = model
            cell.delegate = nil
            cell.delegate = self
            return cell
        }, configureSupplementaryView: { [unowned self] (_, col, identifier, indexPath) -> UICollectionReusableView in
            if identifier == UICollectionView.elementKindSectionHeader {
                let header = col.dequeueReusableSupplementaryView(ofKind:  UICollectionView.elementKindSectionHeader,
                                                                  withReuseIdentifier: "ShopingCarTitleReusableViewID",
                                                                  for: indexPath) as! ShopingCarTitleReusableView
                let sectionModel = self.viewModel.datasource.value[indexPath.section]
                header.model = sectionModel.model
                header.delegate = nil
                header.delegate = self
                return header
            }
            return UICollectionReusableView()
        }, moveItem: { (_, _, _) in
            
        }) { (_, indexPath) -> Bool in
            return false
        }
        
        viewModel.datasource.asDriver()
            .drive(collectionView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
}

extension STShoppingCartViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.width, height: 111)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.width, height: 60)
    }
}

extension STShoppingCartViewController: ShoppingCarCellActions {
    
    func delShop(model: CourseClassModel) {
        viewModel.delShopingSubject.onNext(model)
    }
    
}

extension STShoppingCartViewController: ShopingCarTitleActions {
    
    func section(selected model: SectionCourseClassModel) {
        viewModel.sectionSelectedSubject.onNext(model)
    }
}
