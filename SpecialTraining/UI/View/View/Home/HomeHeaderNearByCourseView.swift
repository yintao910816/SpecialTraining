//
//  HomeHeaderNearByCourseView.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class HomeHeaderNearByCourseView: UICollectionReusableView {

    @IBOutlet var contentView: UICollectionReusableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        contentView = (Bundle.main.loadNibNamed("HomeHeaderNearByCourseView", owner: self, options: nil)?.first as! UICollectionReusableView)
        contentView.correctWidth()
        addSubview(contentView)
        
        layoutIfNeeded()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
