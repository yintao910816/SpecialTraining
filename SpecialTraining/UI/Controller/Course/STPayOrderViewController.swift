//
//  STPayOrderViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/1/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STPayOrderViewController: BaseViewController {

    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet var wchatPayTapGes: UITapGestureRecognizer!
    @IBOutlet var zfbPayTapGes: UITapGestureRecognizer!

    @IBOutlet weak var wchatChoseOutlet: UIButton!
    @IBOutlet weak var zfbChoseOutlet: UIButton!
    @IBOutlet weak var okOutlet: UIButton!
    
    private var classIds: [String] = []
    
    private var payType: PayType = .wchatPay
    
    private var viewModel: PayOrderViewModel!
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        if sender == wchatPayTapGes {
            payType = .wchatPay
            wchatChoseOutlet.isHidden = false
            zfbChoseOutlet.isHidden = true
        }else {
            payType = .alipay
            wchatChoseOutlet.isHidden = true
            zfbChoseOutlet.isHidden = false
        }
    }
    
    override func setupUI() {
        let frame = CGRect.init(x: 0, y: 0, width: okOutlet.width, height: okOutlet.height)
        okOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
    }
    
    override func rxBind() {
        let tapDriver = okOutlet.rx.tap.asDriver().map{ [unowned self] _ in self.payType }
        viewModel = PayOrderViewModel.init(classIds: classIds, tap: tapDriver)
        
        viewModel.gotoPayFinishPaySubject
            .subscribe(onNext: { [weak self] totlePrice in
                self?.performSegue(withIdentifier: "payResultSegue", sender: totlePrice)
            })
            .disposed(by: disposeBag)

        viewModel.priceTextObser.asDriver()
            .drive(priceOutlet.rx.attributedText)
            .disposed(by: disposeBag)
    }
    
    override func prepare(parameters: [String : Any]?) {
        classIds = (parameters!["classIds"] as! [String])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "payResultSegue" {
            segue.destination.prepare(parameters: ["price": sender as! String])
        }
    }
}
