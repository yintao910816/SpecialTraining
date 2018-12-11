//
//  HomeRecommendCollectionVIew.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//

private let headerCarouselID     = "HomeHeaderCarouselViewID"
private let headerNearByCourseID = "HomeHeaderNearByCourseViewID"
private let headerOptimizingID   = "HomeHeaderOptimizingViewID"

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class HomeRecommendCollectionView: UICollectionView {
    
    private let disposeBag = DisposeBag()
    
    public let datasource = Variable([SectionModel<Int, HomeCellSize>]())

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

        register(HomeHeaderCarouselView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCarouselID)
        register(HomeHeaderNearByCourseView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerNearByCourseID)
        register(HomeHeaderOptimizingView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerOptimizingID)
        
        register(UINib.init(nibName: "CourseDisplayCell", bundle: Bundle.main), forCellWithReuseIdentifier: courseDisplayCellID)
        register(UINib.init(nibName: "CourseListCell", bundle: Bundle.main), forCellWithReuseIdentifier: courseListCellID)
        register(UINib.init(nibName: "CourseDisplayMinuteCell", bundle: Bundle.main), forCellWithReuseIdentifier: courseDisplayMinuteCellID)
    }
    
    private func rxBind() {
        rx.setDelegate(self)
            .disposed(by: disposeBag)

        let datasourceSignal = RxCollectionViewSectionedReloadDataSource<SectionModel<Int, HomeCellSize>>.init(configureCell: { (_, col, indexPath, model) -> UICollectionViewCell in
            // 体验专区
            if indexPath.section == 0 {
                let cell = col.dequeueReusableCell(withReuseIdentifier: courseDisplayCellID, for: indexPath) as! CourseDisplayCell
                cell.model = (model as! ExperienceCourseModel)
                return cell
            }
            // 附近课程
            if indexPath.section == 1 {
                let cell = col.dequeueReusableCell(withReuseIdentifier: courseListCellID, for: indexPath) as! CourseListCell
                cell.model = (model as! NearByCourseModel)
                return cell
            }
            // 为你优选
            let cell = col.dequeueReusableCell(withReuseIdentifier: courseDisplayMinuteCellID, for: indexPath)
            return cell
        }, configureSupplementaryView: { [unowned self] (_, col, kind, indexPath) -> UICollectionReusableView in
            // 轮播图部分头部
            if indexPath.section == 0 {
                let colHeader = col.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCarouselID, for: indexPath) as! HomeHeaderCarouselView
                return colHeader
            }
            // 附近课程头部
            if indexPath.section == 1 {
                let colHeader = col.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerNearByCourseID, for: indexPath) as! HomeHeaderNearByCourseView
                return colHeader
            }
            // 为你优选头部
            let colHeader = col.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerOptimizingID, for: indexPath) as! HomeHeaderOptimizingView
            return colHeader
            
            }, moveItem: { _,_,_  in
                
        }) { _,_  -> Bool in
            return false
        }
        
        datasource.asDriver()
            .drive(rx.items(dataSource: datasourceSignal))
            .disposed(by: disposeBag)
    }

}

extension HomeRecommendCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            let carouselHeader = HomeHeaderCarouselView.init(frame: .init(x: 0, y: 0, width: 2*PPScreenW, height: 200))
            return .init(width: PPScreenW, height: carouselHeader.actualHeight)
        case 1:
            return .init(width: PPScreenW, height: 79)
        case 2:
            return .init(width: PPScreenW, height: 45)
        default:
            return .init(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return datasource.value[section].items[1].minimumLineSpacing ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return datasource.value[section].items[1].minimumInteritemSpacing ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return datasource.value[section].items[1].sectionInset ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return datasource.value[indexPath.section].items[indexPath.row].size ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
}
