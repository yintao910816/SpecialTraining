//
//  STHomeViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import SnapKit

class STHomeViewController: BaseViewController {

    @IBOutlet weak var scrollOutlet: UIScrollView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var topNavHeightCns: NSLayoutConstraint!
    @IBOutlet weak var nearByCourseOutlet: UIButton!
    @IBOutlet weak var expericeOutlet: UIButton!
    @IBOutlet weak var recommnedOrganizationOutlet: UIButton!
    @IBOutlet weak var mapOutlet: UIButton!
    
    private var recomendColView: HomeRecommendCollectionView!
    private var organizationColView: HomeOrganizationTableView!
    private var expericeColView: HomeExpericeCollectionView!
    
    private let viewModel = HomeViewModel()

    @IBAction func actions(_ sender: UIButton) {
        if sender == nearByCourseOutlet {
            set(button: nearByCourseOutlet, offsetX: 0)
        }else if sender == expericeOutlet {
            set(button: expericeOutlet, offsetX: scrollOutlet.width)
        }else if sender == recommnedOrganizationOutlet {
            set(button: recommnedOrganizationOutlet, offsetX: scrollOutlet.width * 2)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func set(button: UIButton, offsetX: CGFloat) {
        let btns = [nearByCourseOutlet, expericeOutlet, recommnedOrganizationOutlet]

        if let selectedBtn = btns.first(where: { $0?.isSelected == true }), selectedBtn != nil {
            if selectedBtn != button {
                selectedBtn!.isSelected = false
                selectedBtn!.backgroundColor = RGB(242, 242, 242)

                button.isSelected = true
                button.backgroundColor = ST_MAIN_COLOR_DARK
                scrollOutlet.setContentOffset(.init(x: offsetX, y: 0), animated: true)
            }
        }else {
            button.isSelected = true
            button.backgroundColor = ST_MAIN_COLOR_DARK
            scrollOutlet.setContentOffset(.init(x: offsetX, y: 0), animated: true)
        }
    }
    
    private func set(scroll offsetX: CGFloat) {
        let idx = Int(offsetX / scrollOutlet.width)
        let btns = [nearByCourseOutlet, expericeOutlet, recommnedOrganizationOutlet]
        let curBtn = btns[idx]!
        
        if let selectedBtn = btns.first(where: { $0?.isSelected == true }),
            selectedBtn != nil {
            if selectedBtn != curBtn {
                selectedBtn!.isSelected = false
                selectedBtn!.backgroundColor = RGB(242, 242, 242)
                
                curBtn.isSelected = true
                curBtn.backgroundColor = ST_MAIN_COLOR_DARK
            }
        }else {
            curBtn.isSelected = true
            curBtn.backgroundColor = ST_MAIN_COLOR_DARK
        }
    }

    override func setupUI() {
        if UIDevice.current.isX {
            topNavHeightCns.constant += 24
        }
        
        set(button: nearByCourseOutlet, offsetX: 0)

//        addBarItem(normal: "nav_map_icon", right: true).asDriver()
//            .drive(onNext: { [unowned self] in
//                self.performSegue(withIdentifier: "mapSegue", sender: nil)
//            })
//            .disposed(by: disposeBag)
        
        mapOutlet.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.performSegue(withIdentifier: "mapSegue", sender: nil)
            })
            .disposed(by: disposeBag)
        
        scrollOutlet.contentSize = .init(width: 3*PPScreenW, height: scrollOutlet.height)

        recomendColView = HomeRecommendCollectionView()
        organizationColView = HomeOrganizationTableView()
        expericeColView = HomeExpericeCollectionView()
        
        scrollOutlet.addSubview(recomendColView)
        scrollOutlet.addSubview(organizationColView)
        scrollOutlet.addSubview(expericeColView)

        recomendColView.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet.snp.left)
            $0.top.equalTo(scrollOutlet.snp.top)
            $0.height.equalTo(scrollOutlet.snp.height)
            $0.width.equalTo(PPScreenW)
        }
        
        expericeColView.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet.snp.left).offset(PPScreenW)
            $0.top.equalTo(scrollOutlet.snp.top)
            $0.height.equalTo(scrollOutlet.snp.height)
            $0.width.equalTo(PPScreenW)
        }
        
        organizationColView.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet.snp.left).offset(2*PPScreenW)
            $0.top.equalTo(scrollOutlet.snp.top)
            $0.height.equalTo(scrollOutlet.snp.height)
            $0.width.equalTo(PPScreenW)
        }
        
        if #available(iOS 11, *) {
            scrollOutlet.contentInsetAdjustmentBehavior = .never
            organizationColView.contentInsetAdjustmentBehavior = .never
            recomendColView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    override func rxBind() {
        viewModel.navigationItemTitle.asDriver()
            .drive(onNext: { [unowned self] (ret, title) in
                PrintLog(title)
                self.navigationItem.leftBarButtonItem?.title = title
            })
            .disposed(by: disposeBag)

//        recomendColView.prepare(viewModel.nearByCourseViewModel, NearByCourseItemModel.self, showFooter: true)
//        viewModel.nearByCourseViewModel.nearByCourseSourse.asDriver()
//            .drive(recomendColView.datasource)
//            .disposed(by: disposeBag)

        recomendColView.prepare(viewModel.nearByCourseViewModel, NearCourseListModel.self, showFooter: false)
        viewModel.nearByCourseViewModel.nearByCourseSourse.asDriver()
            .drive(recomendColView.datasource)
            .disposed(by: disposeBag)
        
        expericeColView.prepare(viewModel.expericeCourseViewModel, ExperienceCourseItemModel.self, showFooter: false)
        viewModel.expericeCourseViewModel.experienceCourseSourse.asDriver()
            .drive(expericeColView.datasource)
            .disposed(by: disposeBag)

        organizationColView.prepare(viewModel.nearByOrgnazitionViewModel, NearByOrganizationItemModel.self, showFooter: false)
        viewModel.nearByOrgnazitionViewModel.nearByOrgnazitionSourse.asDriver()
            .drive(organizationColView.datasource)
            .disposed(by: disposeBag)
        
        organizationColView.cellSelected
            .subscribe(onNext: { [unowned self] model in
                self.performSegue(withIdentifier: "organizationShopSegue", sender: model.agn_id)
            })
            .disposed(by: disposeBag)
        
        recomendColView.rx.modelSelected(HomeNearbyCourseItemModel.self)
            .subscribe(onNext: { [unowned self] model in
                self.performSegue(withIdentifier: "courseDetailSegue", sender: model.course_id)
            })
            .disposed(by: disposeBag)
        
        expericeColView.itemDidSelected
            .subscribe(onNext: { [unowned self] model in
                self.performSegue(withIdentifier: "expericeCourseDetailSegue", sender: model.course_id)
            })
            .disposed(by: disposeBag)
        
        recomendColView.clickedIconSubject
            .bind(to: viewModel.clickedIconSubject)
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "organizationSegue" {
            segue.destination.prepare(parameters: ["agn_id": "1"])
        }else if segue.identifier == "expericeCourseDetailSegue" {
            segue.destination.prepare(parameters: ["courseId": sender as! String])
        }else if segue.identifier == "organizationShopSegue" {
            segue.destination.prepare(parameters: ["agn_id": sender as! String])
        }else if segue.identifier == "courseDetailSegue" {
            segue.destination.prepare(parameters: ["course_id": sender as! String])
        }
    }
    
}

extension STHomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        set(scroll: scrollOutlet.contentOffset.x)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            set(scroll: scrollOutlet.contentOffset.x)
        }
    }

}
