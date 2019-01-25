//
//  STMineOrderViewController.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/6.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class STMineOrderViewController: BaseViewController {

    @IBOutlet weak var scrollOutlet: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var moveAnimotionView: UIView!
    
    @IBOutlet weak var needPayOutlet: UIButton!
    @IBOutlet weak var needCourseOutlet: UIButton!
    @IBOutlet weak var needClassOutlet: UIButton!
    @IBOutlet weak var needPayBackOutlet: UIButton!

    private var needPayView: MineNeedPayOrderView!
    private var needCourseView: MineNeedCourseView!
    private var needClassView: MineNeedClassView!
    private var needPayBackView: MineNeedPayBackView!
    
    var viewModel: MineOrderViewModel!
    
    
    @IBAction func actions(_ sender: UIButton) {
        if sender == needPayOutlet {
            set(button: needPayOutlet, offsetX: 0)
        }else if sender == needCourseOutlet {
            set(button: needCourseOutlet, offsetX: scrollOutlet.width)
        }else if sender == needClassOutlet {
            set(button: needClassOutlet, offsetX: scrollOutlet.width * 2)
        }else if sender == needPayBackOutlet {
            set(button: needPayBackOutlet, offsetX: scrollOutlet.width * 3)
        }
    }
    
    private func set(button: UIButton, offsetX: CGFloat) {
        let btns = [needPayOutlet, needCourseOutlet, needClassOutlet, needPayBackOutlet]
        
        if let selectedBtn = btns.first(where: { $0?.isSelected == true }), selectedBtn != nil {
            if selectedBtn != button {
                selectedBtn!.isSelected = false
                selectedBtn!.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                
                button.isSelected = true
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                scrollOutlet.setContentOffset(.init(x: offsetX, y: 0), animated: true)
                moveAnimotionView.snp.remakeConstraints{
                    $0.width.equalTo(view.width / 4.0)
                    $0.height.equalTo(2)
                    $0.centerX.equalTo(button.snp.centerX)
                    $0.bottom.equalTo(headerView)
                }
                
                UIView.animate(withDuration: 0.25) { self.headerView.layoutIfNeeded() }
            }
        }else {
            button.isSelected = true
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            scrollOutlet.setContentOffset(.init(x: offsetX, y: 0), animated: true)
            
            moveAnimotionView.snp.remakeConstraints{
                $0.width.equalTo(view.width / 4.0)
                $0.height.equalTo(2)
                $0.centerX.equalTo(button.snp.centerX)
                $0.bottom.equalTo(headerView)
            }
            
            UIView.animate(withDuration: 0.25) { self.headerView.layoutIfNeeded() }
        }
    }
    
    private func set(scroll offsetX: CGFloat) {
        let idx = Int(offsetX / scrollOutlet.width)
        let btns = [needPayOutlet, needCourseOutlet, needClassOutlet, needPayBackOutlet]
        let curBtn = btns[idx]!
        
        if let selectedBtn = btns.first(where: { $0?.isSelected == true }),
            selectedBtn != nil {
            if selectedBtn != curBtn {
                selectedBtn!.isSelected = false
                selectedBtn!.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                
                curBtn.isSelected = true
                curBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                
                moveAnimotionView.snp.remakeConstraints{
                    $0.width.equalTo(view.width / 4.0)
                    $0.height.equalTo(2)
                    $0.centerX.equalTo(curBtn.snp.centerX)
                    $0.bottom.equalTo(headerView)
                }
                
                UIView.animate(withDuration: 0.25) { self.headerView.layoutIfNeeded() }
            }
        }else {
            curBtn.isSelected = true
            curBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            
            moveAnimotionView.snp.remakeConstraints{
                $0.width.equalTo(view.width / 4.0)
                $0.height.equalTo(2)
                $0.centerX.equalTo(curBtn.snp.centerX)
                $0.bottom.equalTo(headerView)
            }
            
            UIView.animate(withDuration: 0.25) { self.headerView.layoutIfNeeded() }
        }
    }

    
    override func setupUI() {
        title = "我的订单"
//        addBarItem(normal: "", title:"按钮", right: true).drive(onNext: { [unowned self] (_) in
//            PrintLog("点击右上角加号按钮")
//        }).disposed(by: disposeBag)
        
        if #available(iOS 11, *) {
            scrollOutlet.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        moveAnimotionView.snp.remakeConstraints{
            $0.width.equalTo(view.width / 4.0)
            $0.height.equalTo(2)
            $0.centerX.equalTo(needPayOutlet.snp.centerX)
            $0.bottom.equalTo(headerView)
        }
        
        needPayView = MineNeedPayOrderView()
        needCourseView = MineNeedCourseView()
        needClassView  = MineNeedClassView()
        needPayBackView = MineNeedPayBackView()
        
        scrollOutlet.addSubview(needPayView)
        scrollOutlet.addSubview(needCourseView)
        scrollOutlet.addSubview(needClassView)
        scrollOutlet.addSubview(needPayBackView)
    }
    
    override func rxBind() {
        
        viewModel = MineOrderViewModel()
        
        viewModel.needPayDatasource.asDriver()
            .drive(needPayView.datasource)
            .disposed(by: disposeBag)
        
        viewModel.needCourseDatasource.asDriver()
            .drive(needCourseView.datasource)
            .disposed(by: disposeBag)

        viewModel.needClassasource.asDriver()
            .drive(needClassView.datasource)
            .disposed(by: disposeBag)

        viewModel.needPayBackDatasource.asDriver()
            .drive(needPayBackView.datasource)
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollOutlet.contentSize = .init(width: scrollOutlet.width * 4, height: scrollOutlet.height)
        
        needPayView.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet)
            $0.top.equalTo(scrollOutlet)
            $0.width.equalTo(scrollOutlet.width)
            $0.height.equalTo(scrollOutlet.height)
        }
        
        needCourseView.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet).offset(scrollOutlet.width)
            $0.top.equalTo(scrollOutlet)
            $0.width.equalTo(scrollOutlet.width)
            $0.height.equalTo(scrollOutlet.height)
        }
        
        needClassView.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet).offset(scrollOutlet.width * 2)
            $0.top.equalTo(scrollOutlet)
            $0.width.equalTo(scrollOutlet.width)
            $0.height.equalTo(scrollOutlet.height)
        }
        
        needPayBackView.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet).offset(scrollOutlet.width * 3)
            $0.top.equalTo(scrollOutlet)
            $0.width.equalTo(scrollOutlet.width)
            $0.height.equalTo(scrollOutlet.height)
        }

    }
}

extension STMineOrderViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        set(scroll: scrollOutlet.contentOffset.x)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            set(scroll: scrollOutlet.contentOffset.x)
        }
    }

}
