//
//  STResetPassOneViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/12.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STResetPassOneViewController: BaseViewController {

    @IBOutlet weak var nextOutlet: UIButton!
    
    override func setupUI() {
        
        let frame = CGRect.init(x: 0, y: 0, width: nextOutlet.width, height: nextOutlet.height)
        nextOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
        
    }
    
    override func rxBind() {
        
        nextOutlet.rx.tap.asDriver()
            .drive(onNext: { [unowned self] in
                self.performSegue(withIdentifier: "resetSecondSegue", sender: nil)
            })
            .disposed(by: disposeBag)

    }

}
