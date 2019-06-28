


//
//  STExpericeCourseDetailViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/11.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STExpericeCourseDetailViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backTopCns: NSLayoutConstraint!
    @IBOutlet weak var buyOutlet: UIButton!
    @IBOutlet weak var addShoppingCarOutlet: UIButton!
    @IBOutlet weak var bottomCns: NSLayoutConstraint!
    
    private var header: ExpericeCourseDetailHeaderView!
    private var footer: StaticWebView!

    private var viewModel: ExpericeCourseDetailViewModel!
    private var courseId: String = ""
    
    
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
            tableView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }

        backTopCns.constant += LayoutSize.fitTopArea
        addShoppingCarOutlet.set(cornerRadius: 15, borderCorners: [.topLeft, .bottomLeft])
        buyOutlet.set(cornerRadius: 15, borderCorners: [.topRight, .bottomRight])
        
        footer = StaticWebView.init(frame: .init(x: 0, y: 0, width: PPScreenW, height: 400))
        header = ExpericeCourseDetailHeaderView.init(frame: .init(x: 0, y: 0, width: PPScreenW, height: 400))

        tableView.isHidden = true
    }
    
    override func rxBind() {
        viewModel = ExpericeCourseDetailViewModel.init(courseId: courseId)
        
        viewModel.courseInfoObser.asDriver()
            .skip(1)
            .do(onNext: { [weak self] data in
                self?.tableView.isHidden = false
                self?.footer.model = data.course_info
            })
            .drive(header.courseInfoObser)
            .disposed(by: disposeBag)
        
        header.videoPlaySubject
            .bind(to: viewModel.videoPlaySubject)
            .disposed(by: disposeBag)
        
        header.contentHeightObser
            .subscribe(onNext: { [weak self] height in
                guard let strongSelf = self else { return }
                var rect = strongSelf.header.frame
                rect.size.height = height
                strongSelf.header.frame = rect
                
                strongSelf.tableView.tableHeaderView = strongSelf.header
            })
            .disposed(by: disposeBag)
        
        footer.contentSizeObser
            .subscribe(onNext: { [weak self] size in
                guard let strongSelf = self else { return }
                var rect = strongSelf.footer.frame
                rect.size.height = size.height
                strongSelf.footer.frame = rect
                
                strongSelf.tableView.tableFooterView = strongSelf.footer
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
        
    override func prepare(parameters: [String : Any]?) {
        courseId = (parameters!["courseId"] as! String)
    }
}
