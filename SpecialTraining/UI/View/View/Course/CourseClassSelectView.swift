//
//  CourseClassSelectView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/1/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class CourseClassSelectView: BaseFilesOwner {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var iconOutlet: UIButton!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var teacherOutlet: UILabel!
    @IBOutlet weak var collectView: UICollectionView!
    @IBOutlet weak var okOutlet: UIButton!
    
    @IBOutlet weak var mainContentView: UIView!
    private var selectedIndexPath = IndexPath.init(row: 0, section: 0)
    private let disposeBag = DisposeBag()
    
    let dataSource = Variable([CourseClassModel]())
    
    let choseSubject = PublishSubject<CourseClassModel>()
    
    init(controller: UIViewController) {
        super.init()
        
        contentView = (Bundle.main.loadNibNamed("CourseClassSelectView", owner: self, options: nil)?.first as! UIView)
        contentView.correctWidth()
        
        controller.view.addSubview(contentView)
        
        setupUI()
        rxBind()
    }
    
    private func setupUI() {
        let frame = CGRect.init(x: 0, y: 0, width: okOutlet.width, height: okOutlet.height)
        okOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 25
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        let w =  (contentView.width - layout.minimumInteritemSpacing - layout.sectionInset.left - layout.sectionInset.right) / 4.0
        layout.itemSize = .init(width:w, height: 28)
        
        collectView.collectionViewLayout = layout
        
        collectView.register(UINib.init(nibName: "CourseClassSelectedCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CourseClassSelectedCellID")
        
        animotion(animotion: false)
    }
    
    private func rxBind() {
       
        okOutlet.rx.tap.asDriver()
            .map { [unowned self] _ in self.dataSource.value[self.selectedIndexPath.row] }
            .drive(choseSubject)
            .disposed(by: disposeBag)
        
        dataSource.asObservable()
            .bind(to: collectView.rx.items(cellIdentifier: "CourseClassSelectedCellID", cellType: CourseClassSelectedCell.self)) { row, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)

        collectView.rx.itemSelected.asDriver()
            .drive(onNext: { [unowned self] indexPath in
                if indexPath.row != self.selectedIndexPath.row {
                    self.dataSource.value[indexPath.row].isSelected = false
                    self.dataSource.value[self.selectedIndexPath.row].isSelected = true

                    var cell = self.collectView.cellForItem(at: indexPath) as! CourseClassSelectedCell
                    cell.setSelected()
                    
                    cell = self.collectView.cellForItem(at: self.selectedIndexPath) as! CourseClassSelectedCell
                    cell.setSelected()
                    
                    self.selectedIndexPath = indexPath
                }
            })
            .disposed(by: disposeBag)
    }
}

extension CourseClassSelectView {
    
    private func animotion(animotion: Bool) {
        if mainContentView.transform.ty == 0 {
            if animotion == false {
                contentView.backgroundColor = RGB(10, 10, 10, 0)
                mainContentView.transform = CGAffineTransform.init(scaleX: 0, y: mainContentView.height)
            }else {
                UIView.animate(withDuration: 0.25, animations: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.mainContentView.transform = CGAffineTransform.init(scaleX: 0, y: strongSelf.mainContentView.height)
                }) { [weak self] finish in
                    if finish { self?.contentView.backgroundColor = RGB(10, 10, 10, 0.2) }
                }
            }
        }else {
            contentView.backgroundColor = RGB(10, 10, 10, 0.2)
            
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.mainContentView.transform = CGAffineTransform.identity
            })
        }
    }
}
