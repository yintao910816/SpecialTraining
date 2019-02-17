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
        addSubview(contentView)
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
        
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setData<T: CarouselSource>(source: [T]) {
        carouselView.setData(source: source)
    }
    
    var actualHeight: CGFloat {
        get {
            return contentView.viewWithTag(2000)!.frame.maxY
        }
    }
}
