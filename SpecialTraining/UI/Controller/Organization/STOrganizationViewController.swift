//
//  STOrganizationViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/22.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STOrganizationViewController: BaseViewController {

    @IBOutlet weak var scrollOutlet: UIScrollView!
    @IBOutlet weak var topViewHeightCns: NSLayoutConstraint!
    @IBOutlet weak var bottomHeightCns: NSLayoutConstraint!
    
    @IBOutlet weak var homeOutlet: UIButton!
    @IBOutlet weak var courseOutlet: UIButton!
    @IBOutlet weak var teachersBrefOutlet: UIButton!
    @IBOutlet weak var shopOutlet: UIButton!
    @IBOutlet weak var carouseOutlet: CarouselView!
    @IBOutlet weak var titleOutlet: UILabel!
    
    private var physicalStoreTB: PhysicalStoreTableView!
    private var activityBrefTB: ActivityBrefTableView!
    private var recommendCourseTB: RecommendCourseTableView!
    private var teacherCol: TeachersCollectionVIew!
    
    private var viewModel: OrganizationViewModel!
    
    private var agnId: String = ""

    // 被选中的按钮
    private var selectedIdx: Int = 0
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actions(_ sender: UIButton) {
        if sender == homeOutlet {
            setButtonState(selected: 0)
        }else if sender == courseOutlet {
            setButtonState(selected: 1)
        }else if sender == teachersBrefOutlet {
            setButtonState(selected: 2)
        }else if sender == shopOutlet {
            setButtonState(selected: 3)
        }
    }
    
    private func setButtonState(selected idx: Int, _ needScroll: Bool = true) {
        let btns = [homeOutlet, courseOutlet, teachersBrefOutlet, shopOutlet]
        let titles = ["机构介绍", "开设课程", "最强师资", "所有分店"]
        titleOutlet.text = titles[idx]
        if idx != selectedIdx {
            for i in 0..<btns.count {
                if i == idx {
                    // 设置选中
                    btns[i]?.isSelected = true
                    
                    selectedIdx = i
                }else {
                    btns[i]?.isSelected = false
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
        topViewHeightCns.constant += LayoutSize.fitTopArea
        bottomHeightCns.constant += LayoutSize.bottomVirtualArea
        
        scrollOutlet.contentSize = .init(width: PPScreenW * 4, height: scrollOutlet.height)
        
        physicalStoreTB = PhysicalStoreTableView()
        physicalStoreTB.rowHeight = PhysicalStoreModel.cellHeight
        scrollOutlet.addSubview(physicalStoreTB)
        
        recommendCourseTB = RecommendCourseTableView()
        recommendCourseTB.rowHeight = RecommendCourseModel.cellHeight
        scrollOutlet.addSubview(recommendCourseTB)

        activityBrefTB = ActivityBrefTableView()
        activityBrefTB.rowHeight = ActivityBrefModel.cellHeight
        scrollOutlet.addSubview(activityBrefTB)
        
        teacherCol = TeachersCollectionVIew()
        scrollOutlet.addSubview(teacherCol)
        
        physicalStoreTB.register(UINib.init(nibName: "PhysicalStoreCell", bundle: Bundle.main), forCellReuseIdentifier: "PhysicalStoreCellID")
        activityBrefTB.register(UINib.init(nibName: "ActivityBrefCell", bundle: Bundle.main), forCellReuseIdentifier: "ActivityBrefCellID")
        recommendCourseTB.register(UINib.init(nibName: "RecommendCourseCell", bundle: Bundle.main), forCellReuseIdentifier: "RecommendCourseCellID")
    }
    
    override func rxBind() {
        viewModel = OrganizationViewModel.init(agnId: agnId)
        
        viewModel.physicalStoreDatasource.asDriver()
            .drive(physicalStoreTB.rx.items(cellIdentifier: "PhysicalStoreCellID", cellType: PhysicalStoreCell.self)) { (_, model, cell) in
                cell.model = model
                cell.tapShop = { [unowned self] shopId in
                    self.performSegue(withIdentifier: "shopInfoSegue", sender: shopId)
                }
            }
            .disposed(by: disposeBag)
        
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
        
        viewModel.teachersDatasource.asDriver()
            .drive(teacherCol.datasource)
            .disposed(by: disposeBag)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        physicalStoreTB.frame = .init(x: 0, y: 0, width: scrollOutlet.width, height: scrollOutlet.height)
        recommendCourseTB.frame = .init(x: scrollOutlet.width, y: 0, width: scrollOutlet.width, height: scrollOutlet.height)
        activityBrefTB.frame = .init(x: scrollOutlet.width * 2, y: 0, width: scrollOutlet.width, height: scrollOutlet.height)
        teacherCol.frame = .init(x: scrollOutlet.width * 3, y: 0, width: scrollOutlet.width, height: scrollOutlet.height)
    }
    
    override func prepare(parameters: [String : Any]?) {
        agnId = (parameters!["agn_id"] as! String)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shopInfoSegue" {
            segue.destination.prepare(parameters: ["shopId": sender as! String])
        }
    }
}

extension STOrganizationViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            setButtonState(selected: Int(scrollView.contentOffset.x / scrollView.width), false)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setButtonState(selected: Int(scrollView.contentOffset.x / scrollView.width), false)
    }
}
