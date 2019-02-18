//
//  STPublishChoseClassificationViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/10.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STPublishChoseClassificationViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: ChoseClassificationViewModel!
    
    @IBAction func actions(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: NotificationName.PublishVideo.ChooseClassifications,
                                        object: viewModel.appendClassifications())
        navigationController?.popViewController(animated: true)
    }

    override func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = (PPScreenW - 1 - 15 * 2 - 60 * 4) / 3.0
        layout.minimumLineSpacing = 20
        layout.sectionInset = .init(top: 10, left: 15, bottom: 0, right: 15)
        layout.itemSize = .init(width: 60, height: 30)
        
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib.init(nibName: "ChoseClassificationCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ChoseClassificationCellID")

    }
    
    override func rxBind() {
        viewModel = ChoseClassificationViewModel()
        
        viewModel.datasource.asDriver()
            .drive(collectionView.rx.items(cellIdentifier: "ChoseClassificationCellID", cellType: ChoseClassificationCell.self)) { (_, model, cell) in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.asDriver()
            .drive(onNext: { [unowned self] indexPath in
                let cell = self.collectionView.cellForItem(at: indexPath) as! ChoseClassificationCell
                cell.refreshMark()
            })
            .disposed(by: disposeBag)

    }
}
