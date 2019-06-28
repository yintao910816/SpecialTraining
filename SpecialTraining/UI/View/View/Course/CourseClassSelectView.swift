//
//  CourseClassSelectView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/1/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class CourseClassSelectView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectView: UICollectionView!
    @IBOutlet weak var okOutlet: UIButton!
    @IBOutlet weak var mainContentView: UIView!
   
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var addShoppingCarOutlet: UIButton!
    @IBOutlet weak var buyOutlet: UIButton!
    
    private var header: CourseClassSelectHeaderView?
    
    private var selectedIndexPath = IndexPath.init(row: 0, section: 0)
    private let disposeBag = DisposeBag()
    
    let dataSource = Variable([SectionModel<Int, CourseDetailClassModel>]())
    
    let choseSubject = PublishSubject<CourseDetailClassModel>()
    let addShoppingCarSubject = PublishSubject<CourseDetailClassModel>()
    let buySubject = PublishSubject<CourseDetailClassModel>()

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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addShoppingCarOutlet.set(cornerRadius: 20, borderCorners: [.topLeft, .bottomLeft])
        buyOutlet.set(cornerRadius: 20, borderCorners: [.topRight, .bottomRight])
        
        let frame = CGRect.init(x: 0, y: 0, width: okOutlet.width, height: okOutlet.height)
        okOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
                
        mainContentView.set(cornerRadius: 6, borderCorners: [.topLeft, .topRight])
    }

    private func setupUI() {
        collectView.register(UINib.init(nibName: "CourseClassSelectedCell",
                                        bundle: Bundle.main),
                             forCellWithReuseIdentifier: "CourseClassSelectedCellID")
        collectView.register(CourseClassSelectHeaderView.self,
                             forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                             withReuseIdentifier: "CourseClassSelectHeaderViewID")

        let layout = FlowLayoutText()
        layout.scrollDirection = .vertical
        layout.lineSpacing     = 15
        layout.interSpacing    = 10
        layout.itemMinHeight   = 30
        layout.font            = 16
        layout.edgeInsets      = UIEdgeInsets.init(top: 10, left: 10, bottom: 0, right: 10)
        layout.delegate        = self

        collectView.collectionViewLayout = layout
        
        animotion(animotion: false)
    }
    
    private func rxBind() {
        dataSource.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.collectView.reloadData()
            })
            .disposed(by: disposeBag)
        
        okOutlet.rx.tap.asDriver()
            .map { [unowned self] _ ->CourseDetailClassModel in
                self.animotion(animotion: true)
                return self.dataSource.value[self.selectedIndexPath.section].items[self.selectedIndexPath.row]
            }
            .drive(choseSubject)
            .disposed(by: disposeBag)
        
        addShoppingCarOutlet.rx.tap.asDriver()
            .map { [unowned self] _ ->CourseDetailClassModel in
                self.animotion(animotion: true)
                return self.dataSource.value[self.selectedIndexPath.section].items[self.selectedIndexPath.row]
            }
            .drive(addShoppingCarSubject)
            .disposed(by: disposeBag)
        
        buyOutlet.rx.tap.asDriver()
            .map { [unowned self] _ ->CourseDetailClassModel in
                self.animotion(animotion: true)
                return self.dataSource.value[self.selectedIndexPath.section].items[self.selectedIndexPath.row]
            }
            .drive(buySubject)
            .disposed(by: disposeBag)
    }
}

extension CourseClassSelectView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let tempHeader = CourseClassSelectHeaderView.init(frame: .init(x: 0, y: 0, width: collectionView.width, height: 1000))
        if let model = dataSource.value[section].items.first(where: { $0.isSelected == true }) {
            tempHeader.model = model
            return CGSize.init(width: collectionView.width, height: tempHeader.viewHeight())
        }
        return .zero
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.value[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "CourseClassSelectedCellID", for: indexPath) as! CourseClassSelectedCell)
        cell.model = dataSource.value[indexPath.section].items[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if header == nil {
                header = (collectionView.dequeueReusableSupplementaryView(ofKind:  UICollectionView.elementKindSectionHeader,
                                                               withReuseIdentifier: "CourseClassSelectHeaderViewID",
                                                               for: indexPath) as! CourseClassSelectHeaderView)
            }
            let sectionModel = dataSource.value[indexPath.section]
            if let model = sectionModel.items.first(where: { $0.isSelected == true }) { header?.model = model }
            return header!
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != selectedIndexPath.row {
            let selectedModel = dataSource.value[selectedIndexPath.section].items[selectedIndexPath.row]
            let model = dataSource.value[indexPath.section].items[indexPath.row]
            model.isSelected = true
            selectedModel.isSelected = false
            
            selectedIndexPath = indexPath
            
            collectionView.reloadData()
        }
    }
}

extension CourseClassSelectView: FlowLayoutBaseDelegate {    
    
    func itemContent(layout: FlowLayoutBase, indexPath: IndexPath) -> String {
        return dataSource.value[indexPath.section].items[indexPath.row].class_name
    }
    
    func size(forHeader inSection: Int) -> CGSize {
        let tempHeader = CourseClassSelectHeaderView.init(frame: .init(x: 0, y: 0, width: collectView.width, height: 1000))
        if let model = dataSource.value[inSection].items.first(where: { $0.isSelected == true }) {
            tempHeader.model = model
            return CGSize.init(width: collectView.width, height: tempHeader.viewHeight())
        }
        return .zero
    }
}

extension CourseClassSelectView {
    
    func animotion(animotion: Bool, isOkType: Bool = true) {
        okOutlet.isHidden = !isOkType
        bottomView.isHidden = isOkType

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
    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let point = convert(point, to: collectView)
//        if collectView.point(inside: point, with: event) == true {
//            //            moreChoseSubject.onNext(Void())
//            print("集合试图")
//            return collectView
//        }
//        print("自己")
//        return self
//    }
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
