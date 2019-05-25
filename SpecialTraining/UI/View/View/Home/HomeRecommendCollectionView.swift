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
    private var carouseDatas = [AdvertListModel]()
    
    public let datasource = Variable(([SectionModel<Int, HomeCellSize>](), [AdvertListModel]()))
    public let clickedIconSubject = PublishSubject<HomeNearbyCourseItemModel>()

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
        register(UINib.init(nibName: "HomeCourseCell", bundle: Bundle.main), forCellWithReuseIdentifier: courseListCellID)
    }
    
    private func rxBind() {
        rx.setDelegate(self)
            .disposed(by: disposeBag)

        let datasourceSignal = RxCollectionViewSectionedReloadDataSource<SectionModel<Int, HomeCellSize>>.init(configureCell: { (_, col, indexPath, model) -> UICollectionViewCell in
            let cell = col.dequeueReusableCell(withReuseIdentifier: courseListCellID, for: indexPath) as! HomeCourseCell
            cell.model = (model as! HomeNearbyCourseItemModel)
            cell.clickedIconCallBack = { [weak self] model in self?.clickedIconSubject.onNext(model) }
            return cell
        }, configureSupplementaryView: { [unowned self] (_, col, kind, indexPath) -> UICollectionReusableView in
            if indexPath.section == 0 {
                let colHeader = col.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCarouselID, for: indexPath) as! HomeHeaderCarouselView
//                colHeader.setData(source: self.carouseDatas)
                return colHeader
            }
            return UICollectionReusableView()
            }, moveItem: { _,_,_  in
                
        }) { _,_  -> Bool in
            return false
        }
        
        datasource.asDriver()
            .map({ [weak self] data -> [SectionModel<Int, HomeCellSize>] in
                self?.carouseDatas = data.1
                return data.0
            })
            .drive(rx.items(dataSource: datasourceSignal))
            .disposed(by: disposeBag)
    }

}

extension HomeRecommendCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            let carouselHeader = HomeHeaderCarouselView.init(frame: .init(x: 0, y: 0, width: PPScreenW, height: 200))
            return .init(width: PPScreenW, height: carouselHeader.actualHeight)
        }
        return .zero
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
