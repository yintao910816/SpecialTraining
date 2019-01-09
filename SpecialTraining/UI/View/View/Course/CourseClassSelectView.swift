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
    
    @IBAction func closeAction(_ sender: Any) {
        animotion(animotion: true)
    }

    init(controller: UIViewController) {
        super.init()
        
        contentView = (Bundle.main.loadNibNamed("CourseClassSelectView", owner: self, options: nil)?.first as! UIView)
        var frame = contentView.frame
        frame.size.width = controller.view.width
        frame.size.height = controller.view.height
        
        contentView.frame = frame
        
        controller.view.addSubview(contentView)
        
        setupUI()
        rxBind()
    }
    
    private func setupUI() {
        let frame = CGRect.init(x: 0, y: 0, width: okOutlet.width, height: okOutlet.height)
        okOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
        
        mainContentView.set(cornerRadius: 6, borderCorners: [.topLeft, .topRight])
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 25
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        let w =  (contentView.width - layout.minimumInteritemSpacing * 2 - layout.sectionInset.left - layout.sectionInset.right) / 3.0
        layout.itemSize = .init(width:w, height: 28)
        
        collectView.collectionViewLayout = layout
        
        collectView.register(UINib.init(nibName: "CourseClassSelectedCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CourseClassSelectedCellID")
        
        animotion(animotion: false)
    }
    
    private func rxBind() {
       
        okOutlet.rx.tap.asDriver()
            .map { [unowned self] _ ->CourseClassModel in
                self.animotion(animotion: true)
                return self.dataSource.value[self.selectedIndexPath.row]
            }
            .drive(choseSubject)
            .disposed(by: disposeBag)
        
        dataSource.asObservable()
            .do(onNext: { [weak self] in self?.configHeader(model: $0.first) })
            .bind(to: collectView.rx.items(cellIdentifier: "CourseClassSelectedCellID", cellType: CourseClassSelectedCell.self)) { row, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)

        collectView.rx.itemSelected.asDriver()
            .drive(onNext: { [unowned self] indexPath in
                if indexPath.row != self.selectedIndexPath.row {
                    self.configHeader(model: self.dataSource.value[indexPath.row])
                    
                    self.dataSource.value[indexPath.row].isSelected = true
                    self.dataSource.value[self.selectedIndexPath.row].isSelected = false

                    var cell = self.collectView.cellForItem(at: indexPath) as! CourseClassSelectedCell
                    cell.setSelected()
                    
                    cell = self.collectView.cellForItem(at: self.selectedIndexPath) as! CourseClassSelectedCell
                    cell.setSelected()
                    
                    self.selectedIndexPath = indexPath
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func configHeader(model: CourseClassModel?) {
        guard let tempModel = model else { return }
        
        iconOutlet.setImage(tempModel.class_image)
        priceOutlet.text = "￥\(tempModel.price)"
        teacherOutlet.text = "  \(tempModel.teacher_name)  "
    }
}

extension CourseClassSelectView {
    
    func animotion(animotion: Bool) {
        if mainContentView.transform.ty == 0 {
            if animotion == false {
                contentView.isHidden = true
                mainContentView.transform = CGAffineTransform.init(translationX: 0, y: mainContentView.height)
            }else {
                UIView.animate(withDuration: 0.25, animations: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.mainContentView.transform = CGAffineTransform.init(translationX: 0, y: strongSelf.mainContentView.height)
                }) { [weak self] finish in
                    if finish { self?.contentView.isHidden = true }
                }
            }
        }else {
            contentView.isHidden = false
            
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.mainContentView.transform = CGAffineTransform.identity
            })
        }
    }
}

extension CourseClassSelectView: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let point = gestureRecognizer.location(in: contentView)
        if contentView.convert(point, toViewOrWindow: mainContentView).y > 0 {
            return false
        }
        return true
    }
}
