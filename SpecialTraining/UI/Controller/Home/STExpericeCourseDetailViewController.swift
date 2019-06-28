


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
    @IBOutlet weak var backTopCns: NSLayoutConstraint!
    @IBOutlet weak var buyOutlet: UIButton!
    @IBOutlet weak var addShoppingCarOutlet: UIButton!
    @IBOutlet weak var bottomCns: NSLayoutConstraint!
    @IBOutlet weak var scrollContentWidthCns: NSLayoutConstraint!
    
    private var viewModel: ExpericeCourseDetailViewModel!
    private var courseId: String = ""
    
    private var detailView: StaticWebView!
    
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
            if STHelper.userIsLogin() {
                viewModel.insertShoppingCar.onNext(Void())
            }
        }else if sender.tag == 105 {
            // 购买
            if STHelper.userIsLogin() {
                viewModel.buySubject.onNext(Void())
            }
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
        
        detailView = StaticWebView.init(frame: .init(x: 0, y: 0, width: PPScreenW, height: 400))
        scrollView.addSubview(detailView)
        
        detailView.snp.makeConstraints{
            $0.top.equalTo(sepLine.snp.bottom).offset(90 + 16)
            $0.left.right.bottom.equalTo(0)
        }
        
        scrollView.contentSize = .init(width: view.width,
                                       height: view.height)
        
        scrollView.isHidden = true
    }
    
    override func rxBind() {
        viewModel = ExpericeCourseDetailViewModel.init(courseId: courseId)
        
        viewModel.courseInfoObser.asDriver()
            .skip(1)
            .drive(onNext: { [weak self] data in
                guard let strongSelf = self else { return }
                strongSelf.setVideoView(model: data)

                strongSelf.carouselView.setData(source: PhotoModel.creatPhotoModels(photoList: data.course_info.pic_list))
                strongSelf.titleOutlet.text = data.course_info.title
                strongSelf.priceOutlet.text = "¥: \(data.course_info.about_price)"
                
                strongSelf.classInfoOutlet.text = "上课信息：\(data.classList.first?.class_days ?? "0")节"
                strongSelf.sutePeoOutlet.text = "适合人群：\(data.classList.first?.suit_peoples ?? "")"

                strongSelf.detailView.model = data.course_info
                
                strongSelf.scrollView.isHidden = false
            })
            .disposed(by: disposeBag)
        
        detailView.contentSizeObser
            .subscribe(onNext: { [weak self] size in
                guard let strongSelf = self else { return }
                strongSelf.view.setNeedsLayout()
                strongSelf.view.layoutIfNeeded()
                PrintLog("高度；\(strongSelf.detailView.frame.minY)")
                strongSelf.scrollView.contentSize = .init(width: strongSelf.view.width,
                                                          height: strongSelf.detailView.frame.minY + size.height)
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    private func setVideoView(model: CourseDetailModel) {
        if model.videoList.count > 0 {
            let dataArr = model.videoList.count > 3 ? Array(model.videoList[0...2]) : model.videoList
            for idx in 0..<dataArr.count {
                let videoCover = (scrollView.viewWithTag(300 + idx) as! UIButton)
                videoCover.imageView?.contentMode = .scaleAspectFill
                videoCover.isHidden = false
                let videoLable = (scrollView.viewWithTag(400 + idx) as! UILabel)
                videoLable.isHidden = false
                videoCover.setImage(dataArr[idx].res_image)
                videoLable.text = dataArr[idx].res_title
            }
        }else {
            detailView.snp.updateConstraints{
                $0.top.equalTo(sepLine.snp.bottom).offset(10)
            }
        }
    }
    
    override func prepare(parameters: [String : Any]?) {
        courseId = (parameters!["courseId"] as! String)
    }
}
