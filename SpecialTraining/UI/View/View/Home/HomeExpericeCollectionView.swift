//
//  HomeExpericeCollectionView.swift
//  SpecialTraining
//
//  Created by yintao on 2018/12/14.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class HomeExpericeCollectionView: UICollectionView {

    private let disposeBag = DisposeBag()
    
    public let datasource = Variable(([SectionModel<Int, HomeCellSize>](), [AdvertListModel]()))
    
    private var carouseDatas = [AdvertListModel]()

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        
        setupUI()
        rxBind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        if #available(iOS 11, *) {
            contentInsetAdjustmentBehavior = .never
        }
        
        showsVerticalScrollIndicator = false
        backgroundColor = .white
        
        register(HomeHeaderExperienceView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeHeaderExperienceViewID")
        register(UINib.init(nibName: "CourseDisplayMinuteCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CourseDisplayMinuteCellID")
    }
    
    private func rxBind() {
        rx.setDelegate(self)
            .disposed(by: disposeBag)

        let datasourceSignal = RxCollectionViewSectionedReloadDataSource<SectionModel<Int, HomeCellSize>>.init(configureCell: { (_, col, indexPath, model) -> UICollectionViewCell in
            let cell = col.dequeueReusableCell(withReuseIdentifier: "CourseDisplayMinuteCellID", for: indexPath) as! CourseDisplayMinuteCell
            return cell
        }, configureSupplementaryView: { [unowned self] (_, col, kind, indexPath) -> UICollectionReusableView in
            let colHeader = col.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeHeaderExperienceViewID", for: indexPath) as! HomeHeaderExperienceView
            colHeader.setData(source: self.carouseDatas)
            return colHeader
            }, moveItem: { _,_,_  in
                
        }) { _,_  -> Bool in
            return false
        }
        
        datasource.asDriver()
            .map ({ [weak self] data -> [SectionModel<Int, HomeCellSize>] in
                self?.carouseDatas = data.1
                
                return data.0
            })
            .drive(rx.items(dataSource: datasourceSignal))
            .disposed(by: disposeBag)
    }
    
}

extension HomeExpericeCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let carouselHeader = HomeHeaderExperienceView.init(frame: .init(x: 0, y: 0, width: PPScreenW, height: 200))
        return .init(width: PPScreenW, height: carouselHeader.actualHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return datasource.value.0[section].items.first?.minimumLineSpacing ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return datasource.value.0[section].items.first?.minimumInteritemSpacing ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return datasource.value.0[indexPath.section].items[indexPath.row].size ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
