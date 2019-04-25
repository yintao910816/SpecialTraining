//
//  STVerifyOrderViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/1/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift

class STVerifyOrderViewController: BaseViewController {

    @IBOutlet weak var okOutlet: UIButton!
    @IBOutlet weak var totlePriceOutlet: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    // 需要购买的商品
    private var classId: String = ""
    
    private var viewModel: VerifyOrderViewModel!
    
    @IBAction func actions(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoPaySegue", sender: nil)
    }
    
    override func setupUI() {
        let frame = CGRect.init(x: 0, y: 0, width: okOutlet.width, height: okOutlet.height)
        okOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
        
        collectionView.register(UINib.init(nibName: "ShoppingVerifyCell", bundle: Bundle.main),
                                forCellWithReuseIdentifier: "ShoppingVerifyCellID")
        collectionView.register(ShoppingVerifyReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "ShoppingVerifyReusableViewID")
    }
    
    override func rxBind() {
        viewModel = VerifyOrderViewModel.init(classId: classId)

        viewModel.totlePriceObser.asDriver()
            .do(onNext: { print($0) })
            .drive(totlePriceOutlet.rx.attributedText)
            .disposed(by: disposeBag)
        
        let datasource = RxCollectionViewSectionedReloadDataSource<SectionModel<CourseDetailClassModel, CourseDetailClassModel>>.init(configureCell: { (_, col, indexPath, model) -> UICollectionViewCell in
            let cell = col.dequeueReusableCell(withReuseIdentifier: "ShoppingVerifyCellID", for: indexPath) as! ShoppingVerifyCell
            cell.model = model
            return cell
        }, configureSupplementaryView: { [unowned self] (_, col, identifier, indexPath) -> UICollectionReusableView in
            if identifier == UICollectionView.elementKindSectionHeader {
                let header = col.dequeueReusableSupplementaryView(ofKind:  UICollectionView.elementKindSectionHeader,
                                                                  withReuseIdentifier: "ShoppingVerifyReusableViewID",
                                                                  for: indexPath) as! ShoppingVerifyReusableView
                let sectionModel = self.viewModel.datasource.value[indexPath.section]
                header.model = sectionModel.model
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

    }
    
    override func prepare(parameters: [String : Any]?) {
        if let class_id = parameters?["classId"], let id = class_id as? String {
            classId = id
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoPaySegue" {
            segue.destination.prepare(parameters: ["classId": classId])
        }
    }
    
}

extension STVerifyOrderViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.width, height: 143)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return .init(top: 0, left: 10, bottom: 0, right: 10)
        }
        return .init(top: 10, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.width, height: 45)
    }
}
