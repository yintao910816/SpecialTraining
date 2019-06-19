


//
//  STExpericeCourseDetailViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/11.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STExpericeCourseDetailViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var carouselView: CarouselView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var classInfoOutlet: UILabel!
    @IBOutlet weak var sutePeoOutlet: UILabel!
    @IBOutlet weak var sepLine: UIView!
    @IBOutlet weak var contentWidthCns: NSLayoutConstraint!
    @IBOutlet weak var backTopCns: NSLayoutConstraint!
    @IBOutlet weak var buyOutlet: UIButton!
    @IBOutlet weak var addShoppingCarOutlet: UIButton!
    @IBOutlet weak var bottomCns: NSLayoutConstraint!
    @IBOutlet weak var scrollContentWidthCns: NSLayoutConstraint!
    
    private var viewModel: ExpericeCourseDetailViewModel!
    private var courseId: String = ""
    
    private var detailView: CourseDetailInfoView!
    
    @IBAction func actions(_ sender: UIButton) {
        if sender.tag == 100 {
            // 返回
            navigationController?.popViewController(animated: true)
        }else if sender.tag == 101 {
            // 店铺
            viewModel.gotoShopDetailSubject.onNext(Void())
        }else if sender.tag == 102 {
            // 客服
            NoticesCenter.alert(message: "功能暂未开放，客服系统正在努力完善中...")
        }else if sender.tag == 103 {
            // 电话
            let mob = viewModel.courseInfoObser.value.course_info.mob
            if mob.count > 0 {
                STHelper.phoneCall(with: mob)
            }
        }else if sender.tag == 104 {
            // 加入购物车
            viewModel.insertShoppingCar.onNext(Void())
        }else if sender.tag == 105 {
            // 购买
            viewModel.buySubject.onNext(Void())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }

        scrollContentWidthCns.constant = PPScreenW
        
        backTopCns.constant += LayoutSize.fitTopArea
        addShoppingCarOutlet.set(cornerRadius: 15, borderCorners: [.topLeft, .bottomLeft])
        buyOutlet.set(cornerRadius: 15, borderCorners: [.topRight, .bottomRight])
        
        detailView = CourseDetailInfoView.init(frame: view.bounds, showHeader: false)
        scrollView.addSubview(detailView)
        
        detailView.snp.makeConstraints{
            $0.top.equalTo(sepLine.snp.bottom).offset(10)
            $0.width.equalTo(view.snp.width)
//            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(500)
            $0.left.equalTo(0)
        }
        
        scrollView.contentSize = .init(width: view.width,
                                       height: view.height)
    }
    
    override func rxBind() {
        viewModel = ExpericeCourseDetailViewModel.init(courseId: courseId)
        
        viewModel.courseInfoObser.asDriver()
            .drive(onNext: { [weak self] data in
                guard let strongSelf = self else { return }
                strongSelf.carouselView.setData(source: PhotoModel.creatPhotoModels(photoList: data.course_info.pic_list))
                strongSelf.titleOutlet.text = data.course_info.title
                strongSelf.priceOutlet.text = "¥: \(data.course_info.about_price)"
                
                strongSelf.classInfoOutlet.text = "上课信息：\(data.classList.first?.class_days ?? "0")节"
                strongSelf.sutePeoOutlet.text = "适合人群：\(data.classList.first?.suit_peoples ?? "")"

//                strongSelf.contentWidthCns.constant = strongSelf.scrollView.width - 30
//                strongSelf.scrollView.contentSize = .init(width: strongSelf.view.width,
//                                                          height: 330.0 + strongSelf.contentOutlet.height)
                strongSelf.detailView.model = data.course_info
            })
            .disposed(by: disposeBag)
        
//        detailView.contentSizeObser
//            .subscribe(onNext: { [weak self] size in
//                guard let strongSelf = self else { return }
//                strongSelf.scrollView.contentSize = .init(width: strongSelf.view.width,
//                                                          height: 401 + 6 + 10 + size.height)
//            })
//            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
 
    override func prepare(parameters: [String : Any]?) {
        courseId = (parameters!["courseId"] as! String)
    }
}
