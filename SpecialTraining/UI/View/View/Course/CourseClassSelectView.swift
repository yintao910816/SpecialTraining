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

class CourseClassSelectView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var iconOutlet: UIButton!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var teacherOutlet: UILabel!
    @IBOutlet weak var collectView: UICollectionView!
    @IBOutlet weak var okOutlet: UIButton!
    
    @IBOutlet weak var mainContentView: UIView!
    private var selectedIndexPath = IndexPath.init(row: 0, section: 0)
    private let disposeBag = DisposeBag()
    
    let dataSource = Variable([CourseDetailClassModel]())
    
    let choseSubject = PublishSubject<CourseDetailClassModel>()
    
    @IBAction func closeAction(_ sender: Any) {
        animotion(animotion: true)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = RGB(10, 10, 10, 0.3)
        
        contentView = (Bundle.main.loadNibNamed("CourseClassSelectView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints{
            $0.bottom.equalTo(self)
            $0.left.equalTo(self)
            $0.right.equalTo(self)
            $0.height.equalTo(550)
        }
        
        setupUI()
        rxBind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let frame = CGRect.init(x: 0, y: 0, width: okOutlet.width, height: okOutlet.height)
        okOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
        
        mainContentView.set(cornerRadius: 6, borderCorners: [.topLeft, .topRight])
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 25
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        let w =  (contentView.width - layout.minimumInteritemSpacing * 2 - layout.sectionInset.left - layout.sectionInset.right)
        layout.itemSize = .init(width:w / 3.0, height: 28)
        
        collectView.collectionViewLayout = layout
        
        collectView.register(UINib.init(nibName: "CourseClassSelectedCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CourseClassSelectedCellID")
        
        animotion(animotion: false)
    }
    
    private func rxBind() {
       
        okOutlet.rx.tap.asDriver()
            .map { [unowned self] _ ->CourseDetailClassModel in
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
                print(self.selectedIndexPath)
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
    
    private func configHeader(model: CourseDetailClassModel?) {
        guard let tempModel = model else { return }
        
        iconOutlet.setImage(tempModel.pic)
        priceOutlet.text = "￥\(tempModel.price)"
        teacherOutlet.text = "  \(tempModel.teacher_name)  "
    }
}

extension CourseClassSelectView {
    
    func animotion(animotion: Bool) {
        if mainContentView.transform.ty == 0 {
            if animotion == false {
                isHidden = true
                mainContentView.transform = CGAffineTransform.init(translationX: 0, y: mainContentView.height)
            }else {
                UIView.animate(withDuration: 0.25, animations: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.mainContentView.transform = CGAffineTransform.init(translationX: 0, y: strongSelf.mainContentView.height)
                }) { [weak self] finish in
                    if finish { self?.isHidden = true }
                }
            }
        }else {
            isHidden = false
            
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.mainContentView.transform = CGAffineTransform.identity
            })
        }
    }
}

extension CourseClassSelectView: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let point = gestureRecognizer.location(in: contentView)
        if contentView.convert(point, toViewOrWindow: mainContentView).y > 0 {
            return false
        }
        return true
    }
}
