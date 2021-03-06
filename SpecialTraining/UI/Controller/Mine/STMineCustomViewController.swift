//
//  STMineCustomViewController.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/11/30.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit
import RxDataSources

class STMineCustomViewController: BaseViewController {
    
    @IBOutlet weak var topLayout: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel:MineCustomViewModel!
    
    override func setupUI() {
        title = "我的定制"
        
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        topLayout.constant += 20
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 10, left: 15, bottom: 10, right: 15)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing      = 15
        layout.itemSize = .init(width: (PPScreenW - 15*2 - 3*10)/4.0, height: 40)
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib(nibName: "MineCustomCell", bundle: nil), forCellWithReuseIdentifier: "MineCustomCell")
        collectionView.register(UINib(nibName: "MineCustomCollectionReusableHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MineCustomCollectionReusableHeaderView")
        collectionView.register(UINib(nibName: "MineCustomCollectionReusableFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "MineCustomCollectionReusableFooterView")
    }
    
    override func rxBind() {
        viewModel = MineCustomViewModel()
        
        let datasource = RxCollectionViewSectionedReloadDataSource<SectionModel<Int, String>>(configureCell: { (ds, col, indexpath, item) -> UICollectionViewCell in
            let cell = col.dequeueReusableCell(withReuseIdentifier: "MineCustomCell", for: indexpath) as! MineCustomCell
            cell.titleLbl.text = item
            return cell
        }, configureSupplementaryView: { (ds, col, kind, indexpath) -> UICollectionReusableView in
//            if indexpath.section == 3 {
//                let colFooter = col.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "MineCustomCollectionReusableFooterView", for: indexpath) as! MineCustomCollectionReusableFooterView
//                return colFooter
//            }
            let colHeader = col.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MineCustomCollectionReusableHeaderView", for: indexpath) as! MineCustomCollectionReusableHeaderView
            colHeader.titleString = self.viewModel.sectionTitle(indexpath)
            colHeader.delegate = nil
            colHeader.delegate = self
            return colHeader
        }, moveItem: { (_, _, _) in
            
        }) { (_, _) -> Bool in
            return false
        }
        
        viewModel.datasource.asDriver().drive(collectionView.rx.items(dataSource: datasource)).disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.asDriver().drive(onNext: { (index) in
            PrintLog(index)
        }).disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }

}

extension STMineCustomViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let h: CGFloat = UIDevice.current.isX ? 44 : 20
        return section == 0 ? CGSize.init(width: PPScreenW, height: h) : CGSize.init(width: collectionView.width, height: 45)
    }
}

extension STMineCustomViewController: MineSectionHeaderAction {
    
    func addBtnClick() {
        PrintLog("点击了添加按钮")
    }
}
