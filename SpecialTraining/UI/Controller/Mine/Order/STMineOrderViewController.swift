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

    private var totleOrderView: MineOrderView!
    private var noPayOrderView: MineOrderView!
    private var hasPayOrderView: MineOrderView!
    private var payBackOrderView: MineOrderView!

    private var alertView: ApplyForBackAlertView!
    private var cancleAlertView: CancleOrderView!
    
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
        
        totleOrderView = MineOrderView()
        totleOrderView.aDelegate = self
        
        noPayOrderView = MineOrderView()
        noPayOrderView.aDelegate = self

        hasPayOrderView = MineOrderView()
        hasPayOrderView.aDelegate = self

        payBackOrderView = MineOrderView()
        payBackOrderView.aDelegate = self

        alertView = ApplyForBackAlertView()
        cancleAlertView = CancleOrderView()
        
        scrollOutlet.addSubview(totleOrderView)
        scrollOutlet.addSubview(noPayOrderView)
        scrollOutlet.addSubview(hasPayOrderView)
        scrollOutlet.addSubview(payBackOrderView)
        
        view.addSubview(alertView)
        view.addSubview(cancleAlertView)

        alertView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
        cancleAlertView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    override func rxBind() {
        
        NotificationCenter.default.rx.notification(NotificationName.TestNo.alertPayBack)
            .subscribe(onNext: { [unowned self] _ in
                self.alertView.viewAnimotin()
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.TestNo.alertCancleOrder)
            .subscribe(onNext: { [unowned self] _ in
                self.cancleAlertView.viewAnimotin()
            })
            .disposed(by: disposeBag)
        
        viewModel = MineOrderViewModel()
        
        viewModel.totleOrderDatasource.asDriver()
            .drive(totleOrderView.orderDatasource)
            .disposed(by: disposeBag)
        
        viewModel.needPayOrderDatasource.asDriver()
            .drive(noPayOrderView.orderDatasource)
            .disposed(by: disposeBag)

        viewModel.hasPayOrderDatasource.asDriver()
            .drive(hasPayOrderView.orderDatasource)
            .disposed(by: disposeBag)

        viewModel.payBackOrderDatasource.asDriver()
            .drive(payBackOrderView.orderDatasource)
            .disposed(by: disposeBag)

        noPayOrderView.rx.itemSelected.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.performSegue(withIdentifier: "needPayDetailSegue", sender: nil)
            })
            .disposed(by: disposeBag)
        
//        needCourseView.rx.itemSelected.asDriver()
//            .drive(onNext: { [unowned self] _ in
//                self.performSegue(withIdentifier: "needForCourseSegue", sender: nil)
//            })
//            .disposed(by: disposeBag)
//
//        needClassView.rx.itemSelected.asDriver()
//            .drive(onNext: { [unowned self] _ in
//                self.performSegue(withIdentifier: "needForClassSegue", sender: nil)
//            })
//            .disposed(by: disposeBag)
        
        payBackOrderView.rx.itemSelected.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.performSegue(withIdentifier: "payBackInfoSegue", sender: nil)
            })
            .disposed(by: disposeBag)

        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollOutlet.contentSize = .init(width: scrollOutlet.width * 4, height: scrollOutlet.height)
        
        totleOrderView.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet)
            $0.top.equalTo(scrollOutlet)
            $0.width.equalTo(scrollOutlet.width)
            $0.height.equalTo(scrollOutlet.height)
        }
        
        noPayOrderView.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet).offset(scrollOutlet.width)
            $0.top.equalTo(scrollOutlet)
            $0.width.equalTo(scrollOutlet.width)
            $0.height.equalTo(scrollOutlet.height)
        }
        
        hasPayOrderView.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet).offset(scrollOutlet.width * 2)
            $0.top.equalTo(scrollOutlet)
            $0.width.equalTo(scrollOutlet.width)
            $0.height.equalTo(scrollOutlet.height)
        }
        
        payBackOrderView.snp.makeConstraints{
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

extension STMineOrderViewController: UserOperation {
    
    func orderOperation(statu: OrderStatu, orderNum: String) {
        switch statu {
        case .haspay:
            NoticesCenter.alert(title: "退款", message: "订单尚未完成，即将为您安排上课班级，请确认是否要退款", cancleTitle: "取消", okTitle: "确定", presentCtrl: self) { [weak self] in
                self?.viewModel.paybackSubject.onNext(orderNum)
            }
        default:
            break
        }
    }
}
