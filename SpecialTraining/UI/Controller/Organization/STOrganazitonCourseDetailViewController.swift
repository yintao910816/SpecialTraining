//
//  STOrganizationViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/22.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STOrganazitonCourseDetailViewController: BaseViewController {

    @IBOutlet weak var scrollOutlet: UIScrollView!
    @IBOutlet weak var topViewHeightCns: NSLayoutConstraint!
    @IBOutlet weak var bottomHeightCns: NSLayoutConstraint!
    
    @IBOutlet weak var homeOutlet: UIButton!
    @IBOutlet weak var courseOutlet: UIButton!
    @IBOutlet weak var teachersBrefOutlet: UIButton!
    @IBOutlet weak var carouseOutlet: CarouselView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var navLogoOutlet: UIButton!
    @IBOutlet weak var navTitleOutlet: UILabel!
    @IBOutlet weak var locationOutlet: UIButton!
    
    private var activityBrefTB: ActivityBrefTableView!
    private var recommendCourseTB: RecommendCourseTableView!
    private var teacherCol: TeachersCollectionVIew!
    
    private var homeView: AgnDetailHomeView!
    
    private var viewModel: OrganizationViewModel!
    
    private var shopId: String = ""

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
        }
    }
    
    private func setButtonState(selected idx: Int, _ needScroll: Bool = true) {
        let btns = [homeOutlet, courseOutlet, teachersBrefOutlet]
        let titles = ["店铺介绍", "开设课程", "最强师资"]
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
        if #available(iOS 11, *) {
            scrollOutlet.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        locationOutlet.layer.borderWidth = 1
        locationOutlet.layer.borderColor = RGB(37, 167, 250).cgColor
        locationOutlet.layer.cornerRadius = 4
        
        topViewHeightCns.constant += LayoutSize.fitTopArea
        bottomHeightCns.constant += LayoutSize.bottomVirtualArea

        scrollOutlet.contentSize = .init(width: PPScreenW * 3, height: scrollOutlet.height)

        homeView = AgnDetailHomeView.init()
        recommendCourseTB = RecommendCourseTableView()
        teacherCol = TeachersCollectionVIew()

        scrollOutlet.addSubview(homeView)
        scrollOutlet.addSubview(teacherCol)
        scrollOutlet.addSubview(recommendCourseTB)
    }
    
    override func rxBind() {
        viewModel = OrganizationViewModel.init(shopId: shopId,
                                               locationAction: locationOutlet.rx.tap.asDriver())

        viewModel.logoObser.asDriver()
            .drive(navLogoOutlet.rx.image())
            .disposed(by: disposeBag)
        
        viewModel.navTitleObser.asDriver()
            .drive(navTitleOutlet.rx.text)
            .disposed(by: disposeBag)
        
        locationOutlet.rx.tap.asDriver()
            .drive(onNext: { [unowned self] in
                self.performSegue(withIdentifier: "mapSegue", sender: self.viewModel.getCoorInfo())
            })
            .disposed(by: disposeBag)

        viewModel.advListDatasource.asDriver()
            .drive(onNext: { [weak self] data in
                self?.carouseOutlet.setData(source: data)
            })
            .disposed(by: disposeBag)

        viewModel.agnInfoDatasource.asDriver()
            .drive(homeView.datasource)
            .disposed(by: disposeBag)

        viewModel.teachersDatasource.asDriver()
            .drive(teacherCol.datasource)
            .disposed(by: disposeBag)

        viewModel.courseListDatasource.asDriver()
            .drive(recommendCourseTB.datasource)
            .disposed(by: disposeBag)

        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeView.frame = .init(x: 0, y: 0, width: scrollOutlet.width, height: 300)
        recommendCourseTB.frame = .init(x: scrollOutlet.width, y: 0, width: scrollOutlet.width, height: scrollOutlet.height)
        teacherCol.frame = .init(x: scrollOutlet.width * 2, y: 0, width: scrollOutlet.width, height: scrollOutlet.height)
    }
    
    override func prepare(parameters: [String : Any]?) {
        shopId = (parameters!["shop_id"] as! String)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shopInfoSegue" {
            segue.destination.prepare(parameters: ["shopId": sender as! String])
        }else if segue.identifier == "mapSegue" {
            segue.destination.prepare(parameters: sender as? [String: Any])
        }
    }
}

extension STOrganazitonCourseDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            setButtonState(selected: Int(scrollView.contentOffset.x / scrollView.width), false)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setButtonState(selected: Int(scrollView.contentOffset.x / scrollView.width), false)
    }
}
