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
    
    private var selectedIdx: Int = 0
    private var isFirstLoad: Bool = true
    
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
        
        totleOrderView.gotoDetailSubject
            .subscribe(onNext: { [unowned self] model in
                if model.statue == .haspay {
                    self.performSegue(withIdentifier: "hasPayDetailSegue", sender: model)
                }else if model.statue == .noPay {
                    self.performSegue(withIdentifier: "needPayDetailSegue", sender: model)
                }else if model.statue == .packBack {
                    self.performSegue(withIdentifier: "payBackInfoSegue", sender: model)
                }
            })
            .disposed(by: disposeBag)

        noPayOrderView.gotoDetailSubject
            .subscribe(onNext: { [unowned self] in self.performSegue(withIdentifier: "needPayDetailSegue", sender: $0) })
            .disposed(by: disposeBag)
        
        hasPayOrderView.gotoDetailSubject
            .subscribe(onNext: { [unowned self] in self.performSegue(withIdentifier: "hasPayDetailSegue", sender: $0) })
            .disposed(by: disposeBag)
        
        viewModel.gotoPayBackDetail
            .subscribe(onNext: { [unowned self] memberOrder in
                self.performSegue(withIdentifier: "payBackInfoSegue", sender: memberOrder)
            })
            .disposed(by: disposeBag)
        
        payBackOrderView.gotoDetailSubject
            .subscribe(onNext: { [unowned self] in self.performSegue(withIdentifier: "payBackInfoSegue", sender: $0) })
            .disposed(by: disposeBag)

        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstLoad {
            if selectedIdx == 0 {
                set(button: needPayOutlet, offsetX: 0)
            }else if selectedIdx == 1 {
                set(button: needCourseOutlet, offsetX: PPScreenW)
            }else if selectedIdx == 2 {
                set(button: needClassOutlet, offsetX: PPScreenW * 2)
            }else if selectedIdx == 3 {
                set(button: needPayBackOutlet, offsetX: PPScreenW * 3)
            }
            isFirstLoad = false
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "payBackInfoSegue" {
            segue.destination.prepare(parameters: ["model": sender as! MemberAllOrderModel])
        }else if segue.identifier == "needPayDetailSegue" {
            segue.destination.prepare(parameters: ["model": sender as! MemberAllOrderModel])
        }else if segue.identifier == "hasPayDetailSegue" {
            segue.destination.prepare(parameters: ["model": sender as! MemberAllOrderModel])
        }
    }
    
    override func prepare(parameters: [String : Any]?) {
        selectedIdx = (parameters!["idx"] as! Int)
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

    func orderOperation(statu: MineOrderFooterOpType, orderNum: String) {
        viewModel.orderOpretionSubject.onNext((statu, orderNum))
    }
    
}
