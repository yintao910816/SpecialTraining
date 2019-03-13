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
    @IBOutlet weak var navLogoOutlet: UIButton!
    
    private var physicalStoreTB: PhysicalStoreTableView!
    private var activityBrefTB: ActivityBrefTableView!
    private var recommendCourseTB: RecommendCourseTableView!
    private var teacherCol: TeachersCollectionVIew!
    
    private var homeView: AgnDetailHomeView!
    
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
            carouseOutlet.setData(source: viewModel.getAdvData(selectedIdx: 0))
        }else if sender == courseOutlet {
            setButtonState(selected: 1)
            carouseOutlet.setData(source: viewModel.getAdvData(selectedIdx: 1))
        }else if sender == teachersBrefOutlet {
            setButtonState(selected: 2)
            carouseOutlet.setData(source: viewModel.getAdvData(selectedIdx: 2))
        }else if sender == shopOutlet {
            setButtonState(selected: 3)
            carouseOutlet.setData(source: viewModel.getAdvData(selectedIdx: 3))
        }
    }
    
    private func setButtonState(selected idx: Int, _ needScroll: Bool = true) {
        let btns = [homeOutlet, courseOutlet, teachersBrefOutlet, shopOutlet]
        let titles = ["机构介绍", "开设课程", "最强师资", "所有分店"]
        titleOutlet.text = titles[idx]
        if idx != selectedIdx {
            carouseOutlet.setData(source: viewModel.getAdvData(selectedIdx: idx))

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
        
        homeView = AgnDetailHomeView.init()
        physicalStoreTB = PhysicalStoreTableView()
        recommendCourseTB = RecommendCourseTableView()
        teacherCol = TeachersCollectionVIew()
        
        scrollOutlet.addSubview(homeView)
        scrollOutlet.addSubview(teacherCol)
        scrollOutlet.addSubview(physicalStoreTB)
        scrollOutlet.addSubview(recommendCourseTB)
    }
    
    override func rxBind() {
        viewModel = OrganizationViewModel.init(agnId: agnId)
                
        viewModel.advListDatasource.asDriver()
            .drive(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                self?.carouseOutlet.setData(source: strongSelf.viewModel.getAdvData(selectedIdx: strongSelf.selectedIdx))
            })
            .disposed(by: disposeBag)
        
        viewModel.agnInfoDatasource.asDriver()
            .do(onNext: { [weak self] model in self?.navLogoOutlet.setImage(model.logo) })
            .drive(homeView.datasource)
            .disposed(by: disposeBag)
        
        viewModel.teachersDatasource.asDriver()
            .drive(teacherCol.datasource)
            .disposed(by: disposeBag)
        
        viewModel.courseListDatasource.asDriver()
            .drive(recommendCourseTB.datasource)
            .disposed(by: disposeBag)
        
        viewModel.shopListDatasource.asDriver()
            .drive(physicalStoreTB.datasource)
            .disposed(by: disposeBag)

        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeView.frame = .init(x: 0, y: 0, width: scrollOutlet.width, height: 300)
        recommendCourseTB.frame = .init(x: scrollOutlet.width, y: 0, width: scrollOutlet.width, height: scrollOutlet.height)
        teacherCol.frame = .init(x: scrollOutlet.width * 2, y: 0, width: scrollOutlet.width, height: scrollOutlet.height)
        physicalStoreTB.frame = .init(x: scrollOutlet.width * 3, y: 0, width: scrollOutlet.width, height: scrollOutlet.height)
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
