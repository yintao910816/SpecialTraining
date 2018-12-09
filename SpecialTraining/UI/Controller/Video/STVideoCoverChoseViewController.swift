//
//  STVideoCoverChoseViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/9.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit


class STVideoCoverChoseViewController: BaseViewController {

    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var images = [UIImage]()
    
    private var viewModel: VideoCoverChoseViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction func actions(_ sender: UIButton) {
        switch sender.tag {
        case 100:
            navigationController?.popViewController(animated: true)
        case 101:
            performSegue(withIdentifier: "coverToPublishSegue", sender: nil)
        default:
            break
        }
    }
    
    override func setupUI() {
        coverOutlet.image = images.first
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        let w = (PPScreenW - 5*3) / 4.0
        let h = w * 4 / 3.0
        layout.itemSize = .init(width: w, height: h)
        
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib.init(nibName: "VideoCoverChoseCell", bundle: Bundle.main), forCellWithReuseIdentifier: "VideoCoverChoseCellID")
    }
    
    override func rxBind() {
        viewModel = VideoCoverChoseViewModel.init(datas: images)
        
        viewModel.datasource.asDriver()
            .drive(collectionView.rx.items(cellIdentifier: "VideoCoverChoseCellID", cellType: VideoCoverChoseCell.self)) { (_, image, cell) in
                cell.image = image
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(UIImage.self)
            .asDriver().drive(coverOutlet.rx.image)
            .disposed(by: disposeBag)
    }
    
    override func prepare(parameters: [String : Any]?) {
        images = parameters?["data"] as! [UIImage]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ctrl = segue.destination as? STPublishVideoViewController {
            ctrl.prepare(parameters: ["image": coverOutlet.image!])
        }
    }
}
