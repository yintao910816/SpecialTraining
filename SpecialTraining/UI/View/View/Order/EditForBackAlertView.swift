//
//  EditForBackAlertView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/2/24.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class EditForBackAlertView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var okOutlet: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("EditForBackAlertView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
        
        okOutlet.layer.cornerRadius = 4.0
        okOutlet.layer.borderWidth  = 1
        okOutlet.layer.borderColor  = RGB(212, 108, 52).cgColor
        
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
