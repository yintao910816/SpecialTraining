//
//  HomeHeaderExperienceView.swift
//  SpecialTraining
//
//  Created by sw on 14/12/2018.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class HomeHeaderExperienceView: UICollectionReusableView {

    @IBOutlet weak var carouselOutlet: CarouselView!
    @IBOutlet var contentView: UICollectionReusableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        contentView = (Bundle.main.loadNibNamed("HomeHeaderExperienceView", owner: self, options: nil)?.first as! UICollectionReusableView)
        contentView.correctWidth()
        addSubview(contentView)
        
        layoutIfNeeded()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var actualHeight: CGFloat {
        get {
            PrintLog("111 -- \(contentView.viewWithTag(2000)!.frame)")
            
            return contentView.viewWithTag(2000)!.frame.maxY + 10
        }
    }

}