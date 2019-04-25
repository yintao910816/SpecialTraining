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
    
    private var classId: String = ""
    
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
        viewModel = PayOrderViewModel.init(classId: classId, tap: tapDriver)
        
        viewModel.pushNextSubject
            .subscribe(onNext: { [weak self] _ in
                self?.performSegue(withIdentifier: "payResultSegue", sender: nil)
            })
            .disposed(by: disposeBag)

        viewModel.priceTextObser.asDriver()
            .drive(priceOutlet.rx.attributedText)
            .disposed(by: disposeBag)
    }
    
    override func prepare(parameters: [String : Any]?) {
        classId = (parameters!["classId"] as! String)
    }
    
}
