//
//  MineInfoAddStudentView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/3.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class MineInfoAddStudentView: UIView {

    @IBOutlet var contentView: UIView!
    
    public var addStudentCallBack: (() ->())?

    @IBAction func actions(_ sender: Any) {
        addStudentCallBack?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("MineInfoAddStudentView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
