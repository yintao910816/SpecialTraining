//
//  VerifyOrderCOuponCodeView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/7/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxSwift

class VerifyOrderCOuponCodeView: UIView {

    public let buySubject = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var directeBuyOutlet: UIButton!
    @IBOutlet weak var buyFOrCouponCodeOutlet: UIButton!
    @IBOutlet weak var couponCodeTf: UITextField!
    
    @IBAction func actions(_ sender: UIButton) {
        viewAnimotion()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("VerifyOrderCOuponCodeView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }

        buyFOrCouponCodeOutlet.layer.cornerRadius = 15
        buyFOrCouponCodeOutlet.layer.borderColor = RGB(239, 112, 43).cgColor
        buyFOrCouponCodeOutlet.layer.borderWidth = 1
        
        directeBuyOutlet.layer.cornerRadius = 15
        directeBuyOutlet.layer.borderColor = RGB(120, 120, 120).cgColor
        directeBuyOutlet.layer.borderWidth = 1

        couponCodeTf.layer.borderColor = RGB(217, 217, 217).cgColor
        couponCodeTf.layer.borderWidth = 1
        
        isHidden = true
        transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
        
        directeBuyOutlet.rx.tap.map{ "" }
            .do(onNext: { [unowned self] _ in self.viewAnimotion() })
            .bind(to: buySubject)
            .disposed(by: disposeBag)
        
        buyFOrCouponCodeOutlet.rx.tap.map{ [unowned self] in self.couponCodeTf.text ?? "" }
            .do(onNext: { [unowned self] _ in self.viewAnimotion() })
            .bind(to: buySubject)
            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewAnimotion() {
        if isHidden == true {
            isHidden = false
            UIView.animate(withDuration: 0.25, animations: {
                self.transform = CGAffineTransform.identity
            })
        }else {
            endEditing(true)
            UIView.animate(withDuration: 0.25, animations: {
                self.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
            }) { flag in
                if flag { self.isHidden = true }
            }
        }
    }
}
