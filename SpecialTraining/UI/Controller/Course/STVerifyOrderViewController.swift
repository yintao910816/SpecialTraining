//
//  STVerifyOrderViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/1/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STVerifyOrderViewController: BaseViewController {

    @IBOutlet weak var okOutlet: UIButton!
    
    private var parameters: [String : Any]!
    
    @IBAction func actions(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoPaySegue", sender: nil)
    }
    
    override func setupUI() {
        let frame = CGRect.init(x: 0, y: 0, width: okOutlet.width, height: okOutlet.height)
        okOutlet.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
    }
    
    override func prepare(parameters: [String : Any]?) {
        self.parameters = parameters!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoPaySegue" {
            let ctrol = segue.destination
            ctrol.prepare(parameters: parameters)
        }
    }
    
}
