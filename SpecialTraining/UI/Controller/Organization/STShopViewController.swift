//
//  STShopViewController.swift
//  SpecialTraining
//
//  Created by sw on 25/12/2018.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STShopViewController: BaseViewController {

    @IBOutlet weak var scrollOutlet: UIScrollView!
    @IBOutlet weak var topViewHeightCns: NSLayoutConstraint!
    
    @IBOutlet weak var phyicalStoreOutlet: UIButton!
    @IBOutlet weak var recommentCourseOutlet: UIButton!
    @IBOutlet weak var activityBrefOutlet: UIButton!
    @IBOutlet weak var teachersOutlet: UIButton!

    private var activityBrefTB: ActivityBrefTableView!
    private var recommendCourseTB: RecommendCourseTableView!
    private var teacherCol: TeachersCollectionVIew!

    private var viewModel: ShopViewModel!
    
    private var shopId: String = ""
    
    // 被选中的按钮
    private var selectedIdx: Int = 0

    @IBAction func actions(_ sender: UIButton) {
        if sender == phyicalStoreOutlet {
            setButtonState(selected: 0)
        }else if sender == recommentCourseOutlet {
            setButtonState(selected: 1)
        }else if sender == activityBrefOutlet {
            setButtonState(selected: 2)
        }else if sender == teachersOutlet {
            setButtonState(selected: 3)
        }
    }
    
    fileprivate func setButtonState(selected idx: Int, _ needScroll: Bool = true) {
        let btns = [phyicalStoreOutlet, recommentCourseOutlet, activityBrefOutlet, teachersOutlet]
        if idx != selectedIdx {
            for i in 0..<btns.count {
                if i == idx {
                    // 设置选中
                    btns[i]?.isSelected = true
                    btns[i]?.backgroundColor = .white
                    
                    selectedIdx = i
                }else {
                    btns[i]?.isSelected = false
                    btns[i]?.backgroundColor = .clear
                }
            }
            
            if needScroll == true {
                scrollOutlet.setContentOffset(.init(x: scrollOutlet.width * CGFloat(idx), y: 0), animated: false)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        topViewHeightCns.constant += UIDevice.current.isX ? 0 : 24
        
        scrollOutlet.contentSize = .init(width: PPScreenW * 4, height: scrollOutlet.height)
        
        recommendCourseTB = RecommendCourseTableView()
        recommendCourseTB.rowHeight = RecommendCourseModel.cellHeight
        scrollOutlet.addSubview(recommendCourseTB)
        
        activityBrefTB = ActivityBrefTableView()
        activityBrefTB.rowHeight = ActivityBrefModel.cellHeight
        scrollOutlet.addSubview(activityBrefTB)
        
        teacherCol = TeachersCollectionVIew()
        scrollOutlet.addSubview(teacherCol)
        
        activityBrefTB.register(UINib.init(nibName: "ActivityBrefCell", bundle: Bundle.main), forCellReuseIdentifier: "ActivityBrefCellID")
        recommendCourseTB.register(UINib.init(nibName: "RecommendCourseCell", bundle: Bundle.main), forCellReuseIdentifier: "RecommendCourseCellID")
    }
    
    override func rxBind() {
        viewModel = ShopViewModel.init(shopId: shopId)
        
        viewModel.activityBrefDatasource.asDriver()
            .drive(activityBrefTB.rx.items(cellIdentifier: "ActivityBrefCellID", cellType: ActivityBrefCell.self)) { (_, model, cell) in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        viewModel.recommendCourseDatasource.asDriver()
            .drive(recommendCourseTB.rx.items(cellIdentifier: "RecommendCourseCellID", cellType: RecommendCourseCell.self)) { (_, model, cell) in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
//        viewModel.teachersDatasource.asDriver()
//            .drive(teacherCol.datasource)
//            .disposed(by: disposeBag)
    }
    
    override func prepare(parameters: [String : Any]?) {
        shopId = parameters!["shopId"] as! String
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        recommendCourseTB.frame = .init(x: scrollOutlet.width, y: 0, width: scrollOutlet.width, height: scrollOutlet.height)
        activityBrefTB.frame = .init(x: scrollOutlet.width * 2, y: 0, width: scrollOutlet.width, height: scrollOutlet.height)
        teacherCol.frame = .init(x: scrollOutlet.width * 3, y: 0, width: scrollOutlet.width, height: scrollOutlet.height)
    }

}

extension STShopViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            setButtonState(selected: Int(scrollView.contentOffset.x / scrollView.width), false)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setButtonState(selected: Int(scrollView.contentOffset.x / scrollView.width), false)
    }
}
