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
    
    private var model: CourseClassModel!
    
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

        let priceText = "￥\(model.price)"
        priceOutlet.attributedText = priceText.attributed([NSRange.init(location: 0, length: 1)], font: [UIFont.systemFont(ofSize: 13)])
    }
    
    override func rxBind() {
        viewModel = PayOrderViewModel.init(input: (model: model, payType: payType),
                                           tap: okOutlet.rx.tap.asDriver())
    }
    
    override func prepare(parameters: [String : Any]?) {
        model = (parameters!["model"] as! CourseClassModel)
    }
    
}
