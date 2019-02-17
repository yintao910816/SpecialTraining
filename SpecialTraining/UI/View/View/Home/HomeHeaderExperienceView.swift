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
        addSubview(contentView)
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }

        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setData<T: CarouselSource>(source: [T]) {
        carouselOutlet.setData(source: source)
    }

    var actualHeight: CGFloat {
        get {
            return contentView.viewWithTag(2000)!.frame.maxY
        }
    }

}
