//
//  OrganizationHeaderView.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/17.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class OrganizationHeaderView: BaseFilesOwner {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var carouselOutlet: CarouselView!
    
    override init() {
        super.init()
        
        contentView = (Bundle.main.loadNibNamed("OrganizationHeaderView", owner: self, options: nil)!.first as! UIView)
        contentView.correctWidth()
        
        contentView.layoutIfNeeded()
    }
    
    var actualHeight: CGFloat {
        get {
            return contentView.viewWithTag(2000)!.frame.maxY + 10
        }
    }
}
