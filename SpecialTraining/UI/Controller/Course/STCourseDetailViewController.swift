//
//  STCourseDetailViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2018/12/14.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class STCourseDetailViewController: BaseViewController {

    private var viewModel: CourseDetailViewModel!
    
    private var splendidnessContentTB: SplendidnessContentTableView!
    private var courseTimeTB: CourseTimeTableView!
    private var courseAudioTB: CourseAudioTableView!
    private var courseSchoolTB: CourseSchoolTableView!
    
    private var selectedClassView: CourseClassSelectView!
    
    private var courseId: String = ""
    
    @IBOutlet weak var scrollOutlet: UIScrollView!
    
    @IBOutlet weak var conentOutlet: UIButton!
    @IBOutlet weak var courseTimeOutlet: UIButton!
    @IBOutlet weak var courseAudioOutlet: UIButton!
    @IBOutlet weak var courseSchoolOutlet: UIButton!
    
    @IBOutlet weak var bannerOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    
    private var isGotopay: Bool = false
    
    @IBAction func actions(_ sender: UIButton) {

        if sender == conentOutlet {
            set(button: conentOutlet, offsetX: 0)
        }else if sender == courseTimeOutlet {
            set(button: courseTimeOutlet, offsetX: scrollOutlet.width)
        }else if sender == courseAudioOutlet {
            set(button: courseAudioOutlet, offsetX: scrollOutlet.width * 2)
        }else if sender == courseSchoolOutlet {
            set(button: courseSchoolOutlet, offsetX: scrollOutlet.width * 3)
        }
    }
    
    @IBAction func bottomAction(_ sender: UIButton) {
        switch sender.tag {
        case 5000:
            // 店铺
            break
        case 5001:
            // 客服
            break
        case 5002:
            // 电话
            break
        case 5003:
            // 加入购物车
            selectedClassView.animotion(animotion: true)
            isGotopay = false
        case 5004:
            // 立即购买
            selectedClassView.animotion(animotion: true)
            isGotopay = true
        default:
            break
        }
    }
    
    
    private func set(button: UIButton, offsetX: CGFloat) {
        let btns = [conentOutlet, courseTimeOutlet, courseAudioOutlet, courseSchoolOutlet]
        
        if let selectedBtn = btns.first(where: { $0?.isSelected == true }), selectedBtn != nil {
            if selectedBtn != button {
                selectedBtn!.isSelected = false
                selectedBtn!.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                
                button.isSelected = true
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                scrollOutlet.setContentOffset(.init(x: offsetX, y: 0), animated: true)
            }
        }else {
            button.isSelected = true
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            scrollOutlet.setContentOffset(.init(x: offsetX, y: 0), animated: true)
        }
    }
    
    private func set(scroll offsetX: CGFloat) {
        let idx = Int(offsetX / scrollOutlet.width)
        let btns = [conentOutlet, courseTimeOutlet, courseAudioOutlet, courseSchoolOutlet]
        let curBtn = btns[idx]!
        
        if let selectedBtn = btns.first(where: { $0?.isSelected == true }),
            selectedBtn != nil {
            if selectedBtn != curBtn {
                selectedBtn!.isSelected = false
                selectedBtn!.titleLabel?.font = UIFont.systemFont(ofSize: 14)

                curBtn.isSelected = true
                curBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            }
        }else {
            curBtn.isSelected = true
            curBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        }
    }

    override func setupUI() {
        navigationItem.title = "课程详情"
        
        selectedClassView = CourseClassSelectView.init(controller: self)
        
        
        set(button: conentOutlet, offsetX: 0)
        
        scrollOutlet.contentSize = .init(width: 4*PPScreenW, height: scrollOutlet.height)
        
        splendidnessContentTB = SplendidnessContentTableView()
        courseTimeTB = CourseTimeTableView()
        courseAudioTB = CourseAudioTableView()
        courseSchoolTB = CourseSchoolTableView()

        scrollOutlet.addSubview(splendidnessContentTB)
        scrollOutlet.addSubview(courseTimeTB)
        scrollOutlet.addSubview(courseAudioTB)
        scrollOutlet.addSubview(courseSchoolTB)

        splendidnessContentTB.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet.snp.left)
            $0.top.equalTo(scrollOutlet.snp.top)
            $0.height.equalTo(scrollOutlet.snp.height)
            $0.width.equalTo(PPScreenW)
        }
        
        courseTimeTB.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet.snp.left).offset(PPScreenW)
            $0.top.equalTo(scrollOutlet.snp.top)
            $0.height.equalTo(scrollOutlet.snp.height)
            $0.width.equalTo(PPScreenW)
        }

        courseAudioTB.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet.snp.left).offset(2*PPScreenW)
            $0.top.equalTo(scrollOutlet.snp.top)
            $0.height.equalTo(scrollOutlet.snp.height)
            $0.width.equalTo(PPScreenW)
        }
        
        courseSchoolTB.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet.snp.left).offset(3*PPScreenW)
            $0.top.equalTo(scrollOutlet.snp.top)
            $0.height.equalTo(scrollOutlet.snp.height)
            $0.width.equalTo(PPScreenW)
        }
        
//        if #available(iOS 11, *) {
//            scrollOutlet.contentInsetAdjustmentBehavior = .never
//            organizationColView.contentInsetAdjustmentBehavior = .never
//            recomendColView.contentInsetAdjustmentBehavior = .never
//        }else {
//            automaticallyAdjustsScrollViewInsets = false
//        }

    }
    
    override func rxBind() {
        viewModel = CourseDetailViewModel.init(courseId: courseId)
        
        viewModel.splendidnessContentSource
            .asDriver()
            .drive(splendidnessContentTB.datasource)
            .disposed(by: disposeBag)
        
        viewModel.classTimeSource
            .asDriver()
            .drive(courseTimeTB.datasource)
            .disposed(by: disposeBag)

        viewModel.splendidnessContentSource
            .asDriver()
            .drive(courseAudioTB.datasource)
            .disposed(by: disposeBag)

        viewModel.relateShopSource
            .asDriver()
            .drive(courseSchoolTB.datasource)
            .disposed(by: disposeBag)
        
        viewModel.bannerSource
            .subscribe(onNext: { [weak self] in self?.setBanner(data: $0) })
            .disposed(by: disposeBag)
        
        viewModel.selecteClassSource.asDriver()
            .drive(selectedClassView.dataSource)
            .disposed(by: disposeBag)
        
        selectedClassView.choseSubject
            .subscribe(onNext: { [unowned self] model in
                self.performSegue(withIdentifier: "verifyOrderOutlet", sender: model)
            })
            .disposed(by: disposeBag)
    }
    
    private func setBanner(data: CourseDetailBannerModel) {
        bannerOutlet.setImage(data.top_pic)
        priceOutlet.text = "￥\(data.about_price)"
        titleOutlet.text = data.title
    }
    
    override func prepare(parameters: [String : Any]?) {
        courseId = parameters!["course_id"] as! String
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verifyOrderOutlet" {
            // 确认订单
            let ctrol = segue.destination
            ctrol.prepare(parameters: ["model": sender!, "shop_id": viewModel.shopId])
        }
    }
}

extension STCourseDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        set(scroll: scrollOutlet.contentOffset.x)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            set(scroll: scrollOutlet.contentOffset.x)
        }
    }
    
}

