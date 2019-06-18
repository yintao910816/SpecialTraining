//
//  STClassDetailViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/4/25.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift

class STClassDetailViewController: BaseViewController {
    
    @IBOutlet weak var buyOutlet: UIButton!
    @IBOutlet weak var addShoppingCarOutlet: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var header: ClassDetailHeaderReusableView!
    private var footer: ClassDetailFooterReusableView!
    
    private var viewModel: ClassDetailViewModel!
    
    private var gotoLessionDetailDispose: Disposable?
    
    private var classId: String = ""
    private var shopId: String  = ""
    
    private var webContentSize: CGSize = .init(width: PPScreenW, height: 200)
    
    @IBAction func actions(_ sender: UIButton) {
        if sender.tag == 200 {
            // 客服
            NoticesCenter.alert(message: "功能暂未开放，客服系统正在努力完善中...")
        }else if sender.tag == 201 {
            // 电话
            let mob = viewModel.shopInfo.mob
            if mob.count > 0 {
                STHelper.phoneCall(with: mob)
            }
        }else if sender.tag == 202 {
            // 加入购物车
            viewModel.insertShoppingCar.onNext(Void())
        }else if sender.tag == 203 {
            // 购买
            viewModel.buySubject.onNext(Void())
        }else if sender.tag == 204 {
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func setupUI() {
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }

        addShoppingCarOutlet.set(cornerRadius: 15, borderCorners: [.topLeft, .bottomLeft])
        buyOutlet.set(cornerRadius: 15, borderCorners: [.topRight, .bottomRight])

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 10, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 8
        let w = (PPScreenW - 1 - 5 * 2 - 10 * 2) / 3.0
        let h = w + 5 + 16
        layout.itemSize = .init(width: w, height: h)
        
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib.init(nibName: "ClassDetailVideoCell", bundle: Bundle.main),
                                forCellWithReuseIdentifier: "ClassDetailVideoCellID")
        collectionView.register(ClassDetailHeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        collectionView.register(ClassDetailFooterReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: "footer")
    }
    
    override func rxBind() {
        viewModel = ClassDetailViewModel.init(classId: classId, shopId: shopId)
        
        let datasource = RxCollectionViewSectionedReloadDataSource<SectionModel<CourseDetailClassModel,CourseDetailVideoModel>>.init(configureCell: { (section, col, indexPath, model) -> UICollectionViewCell in
            let cell = col.dequeueReusableCell(withReuseIdentifier: "ClassDetailVideoCellID", for: indexPath) as! ClassDetailVideoCell
            cell.model = model
            return cell
        }, configureSupplementaryView: { [weak self] (section, col, kind, indexpath) -> UICollectionReusableView in
            if kind == UICollectionView.elementKindSectionHeader {
                let header = col.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                  withReuseIdentifier: "header",
                                                                  for: indexpath) as! ClassDetailHeaderReusableView
                header.model = section.sectionModels[indexpath.section].model
                if let strongSelf = self {
                    strongSelf.gotoLessionDetailDispose?.dispose()
                    strongSelf.gotoLessionDetailDispose = header.lessionListOutlet.rx.tap.asDriver()
                        .drive(onNext: {
                            strongSelf.performSegue(withIdentifier: "lessionListSegue", sender: nil)
                        })
                    
                    header.changeVideoOutlet.rx.tap.asDriver()
                        .drive(strongSelf.viewModel.changeVideoSubject)
                        .disposed(by: strongSelf.disposeBag)
                }

                return header
            }
            if kind == UICollectionView.elementKindSectionFooter {
                let footer = col.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                  withReuseIdentifier: "footer",
                                                                  for: indexpath) as! ClassDetailFooterReusableView
                footer.classId = self?.classId ?? "1"
                if let strongSelf = self {
                    footer.contentSizeObser
                        .do(onNext: { [weak self] in self?.webContentSize = $0 })
                        .bind(to: strongSelf.viewModel.contentSizeObser)
                        .disposed(by: strongSelf.disposeBag)
                }
                return footer
            }
            return UICollectionReusableView()
        }, moveItem: { _,_,_  in
            
        }) { _,_  -> Bool in
            return false
        }

        collectionView.rx.modelSelected(CourseDetailVideoModel.self)
            .asDriver()
            .drive(viewModel.playVideoSubject)
            .disposed(by: disposeBag)
        
        viewModel.videoListObser.asDriver()
            .drive(collectionView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func prepare(parameters: [String : Any]?) {
        classId = (parameters!["classId"] as! String)
        shopId  = (parameters!["shopId"] as! String)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lessionListSegue" {
            segue.destination.prepare(parameters: ["data": viewModel.lessionList])
        }
    }
}

extension STClassDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let header = ClassDetailHeaderReusableView.init(frame: .init(x: 0, y: 0, width: PPScreenW, height: 400))
        let realHeight = header.realHeight
//        return .init(width: collectionView.width, height: 404)
        PrintLog("真实高度：\(realHeight)")
        return .init(width: collectionView.width, height: realHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: collectionView.width, height: webContentSize.height)
    }
}
