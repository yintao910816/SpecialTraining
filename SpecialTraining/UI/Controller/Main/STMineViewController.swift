//
//  STMineViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxDataSources

class STMineViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: MineViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 10, left: 15, bottom: 10, right: 15)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing      = 15
        layout.itemSize = .init(width: (PPScreenW - 15*2 - 3*10)/4.0, height: 62)
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib.init(nibName: "MineCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MineCellID")
        collectionView.register(MineHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MineHeaderCollectionReusableViewID")
        collectionView.register(MineSectionCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MineSectionCollectionReusableViewID")
    }
    
    override func rxBind() {
        viewModel = MineViewModel()
        
        let datasource = RxCollectionViewSectionedReloadDataSource<SectionModel<Int, MineModel>>.init(configureCell: { (_, col, indexPath, model) -> UICollectionViewCell in
            let cell = col.dequeueReusableCell(withReuseIdentifier: "MineCellID", for: indexPath) as! MineCell
            cell.model = model
            return cell
        }, configureSupplementaryView: { [unowned self] (_, col, kind, indexPath) -> UICollectionReusableView in
            if indexPath.section == 0 {
                let colHeader = col.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MineHeaderCollectionReusableViewID", for: indexPath) as! MineHeaderCollectionReusableView
                colHeader.delegate = nil
                colHeader.delegate = self
                return colHeader
            }
            let colHeader = col.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MineSectionCollectionReusableViewID", for: indexPath) as! MineSectionCollectionReusableView
            colHeader.title = self.viewModel.sectionTitle(indexPath)
            return colHeader
            }, moveItem: { _,_,_  in
                
        }) { _,_  -> Bool in
            return false
        }
        
        viewModel.datasource.asDriver()
            .drive(collectionView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(MineModel.self)
            .asDriver()
            .drive(onNext: { [unowned self] model in
                if let segue = model.segueIdentifier {
                    self.performSegue(withIdentifier: segue, sender: nil)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension STMineViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let h: CGFloat = UIDevice.current.isX ? (350 + 44) : (350 + 20)
        return section == 0 ? CGSize.init(width: PPScreenW, height: h) : CGSize.init(width: collectionView.width, height: 45)
    }
}

extension STMineViewController: MineHeaderActions, VMNavigation {
    
    func gotoMineInfo() {
        performSegue(withIdentifier: "mineInfoSegue", sender: nil)
    }
    
    func gotoSetting() {
        performSegue(withIdentifier: "settingSegue", sender: nil)
    }

    func gotoMineCourse() {
        performSegue(withIdentifier: "mineCourse", sender: nil)
    }
    
    func gotoMineAccount() {
        performSegue(withIdentifier: "mineAccount", sender: nil)
    }
    
    func gotoMineRecommend() {
        performSegue(withIdentifier: "myRecommendSegue", sender: nil)
    }
}
