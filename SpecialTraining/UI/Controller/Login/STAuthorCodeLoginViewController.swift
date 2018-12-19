//
//  STAuthorCodeLoginViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/13.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STAuthorCodeLoginViewController: BaseViewController {
    
    @IBOutlet weak var contentBgView: UIView!
    
    @IBOutlet weak var loginOutlet: UIButton!
    @IBOutlet weak var phoneOutlet: UITextField!
    @IBOutlet weak var codeOutlet: UITextField!
    @IBOutlet weak var wchatOutlet: UIButton!
    
    @IBOutlet weak var authorOutlet: UIButton!

    @IBOutlet weak var topBgHeightCns: NSLayoutConstraint!
    
    @IBAction func actions(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        topBgHeightCns.constant += UIDevice.current.isX ? 44 : 0
                
        let frame = CGRect.init(x: 0, y: 0, width: loginOutlet.width, height: loginOutlet.height)
        loginOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
        
    }
    
    override func rxBind() {
        wchatOutlet.rx.tap.asDriver()
            .drive(onNext: { [unowned self] in
                self.performSegue(withIdentifier: "bindPhoneTwoSegue", sender: nil)
            })
            .disposed(by: disposeBag)
    }
}
