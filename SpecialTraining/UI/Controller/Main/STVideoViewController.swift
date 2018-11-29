//
//  STVideoViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class STVideoViewController: BaseViewController {

    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    @IBOutlet weak var topViewHeightCns: NSLayoutConstraint!
    @IBOutlet weak var topViewTopCns: NSLayoutConstraint!
    
    var viewModel: VideoViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        if #available(iOS 11, *) {
            contentCollectionView.contentInsetAdjustmentBehavior = .never
//            menuCollectionView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }

        topViewHeightCns.constant += (LayoutSize.topVirtualArea + 20)
        
        let layout = VideoFlowLayout.init()
        layout.interSpacing = 7
        layout.lineSpacing  = 7
        layout.edgeInsets   = .init(top: 7, left: 7, bottom: 7, right: 7)
        layout.delegate = self
        
        contentCollectionView.collectionViewLayout = layout
        
        contentCollectionView.register(UINib.init(nibName: "VideoCell", bundle: Bundle.main), forCellWithReuseIdentifier: "VideoCellID")
        menuCollectionView.register(UINib.init(nibName: "VideoClassificationCell", bundle: Bundle.main), forCellWithReuseIdentifier: "VideoClassificationCellID")
    }
    
    override func rxBind() {
        viewModel = VideoViewModel()
        
        viewModel.datasource
            .asObservable()
            .bind(to: contentCollectionView.rx.items(cellIdentifier: "VideoCellID", cellType: VideoCell.self)) { [unowned self] (row, element, cell) in
                PrintLog(row)
            }
            .disposed(by: disposeBag)

        viewModel.videoClassifationSource
            .asObservable()
            .bind(to: menuCollectionView.rx.items(cellIdentifier: "VideoClassificationCellID", cellType: VideoClassificationCell.self)) { (row, element, cell) in
                cell.model = element
            }
            .disposed(by: disposeBag)
        
        menuCollectionView.rx.modelSelected(VideoClassificationModel.self)
            .asDriver()
            .drive(viewModel.classifationChangeObser)
            .disposed(by: disposeBag)

    }
}

extension STVideoViewController: FlowLayoutDelegate {
    
    func itemContent(layout: BaseFlowLayout, indexPath: IndexPath) -> CGSize {
        let model = viewModel.datasource.value[indexPath.row]
        return .init(width: model.width, height: model.height)
    }
}
