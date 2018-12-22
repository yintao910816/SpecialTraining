//
//  HomeHeaderCarouselView.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class HomeHeaderCarouselView: UICollectionReusableView {
    
    @IBOutlet var contentView: UICollectionReusableView!
    
    @IBOutlet weak var carouselView: CarouselView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        contentView = (Bundle.main.loadNibNamed("HomeHeaderCarouselView", owner: self, options: nil)?.first as! UICollectionReusableView)
        contentView.correctWidth()
        addSubview(contentView)
        
        layoutIfNeeded()
        
        PrintLog("222 -- \(contentView.viewWithTag(2000)!.frame)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setData<T: CarouselSource>(source: [T]) {
        carouselView.setData(source: source)
    }
    
    var actualHeight: CGFloat {
        get {
            PrintLog("111 -- \(contentView.viewWithTag(2000)!.frame)")

            return contentView.viewWithTag(2000)!.frame.maxY + 10
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        PrintLog("333 -- \(contentView.viewWithTag(2000)!.frame)")
    }
}
