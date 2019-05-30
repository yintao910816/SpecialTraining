//
//  STFinishPayViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/1/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STFinishPayViewController: BaseViewController {

    @IBOutlet weak var headerBgView: UIView!
    @IBOutlet weak var bgHeightCns: NSLayoutConstraint!
    @IBOutlet weak var topCns: NSLayoutConstraint!
    @IBOutlet weak var payCountOutlet: UILabel!
    
    private var priceText: String = "0"
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        if UIDevice.current.isX == true {
            topCns.constant = topCns.constant + 44
            bgHeightCns.constant = bgHeightCns.constant + 44
        }
        
        let frame = CGRect.init(x: 0, y: 0, width: headerBgView.width, height: bgHeightCns.constant)
        headerBgView.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
        
        payCountOutlet.text = "实付：\(priceText)"
    }
    
    override func rxBind() {
        
    }
    
    override func prepare(parameters: [String : Any]?) {
        priceText = (parameters!["price"] as! String)
    }
}
