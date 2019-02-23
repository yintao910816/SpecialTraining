//
//  ApplyForBackAlertView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/2/24.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class ApplyForBackAlertView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var okOutlet: UIButton!
    @IBOutlet weak var cancleOutlet: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("ApplyForBackAlertView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
        
        cancleOutlet.layer.cornerRadius = 4.0
        cancleOutlet.layer.borderWidth  = 1
        cancleOutlet.layer.borderColor  = RGB(212, 108, 52).cgColor
        
        okOutlet.layer.cornerRadius = 4.0
        okOutlet.layer.borderWidth  = 1
        okOutlet.layer.borderColor  = RGB(60, 60, 60).cgColor
        
        isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func actions(_ sender: Any) {
        viewAnimotin()
    }
    
    func viewAnimotin() {
        isHidden = !isHidden
    }
}
