//
//  OrganizationHeaderView.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/17.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class OrganizationHeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var carouselOutlet: CarouselView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("OrganizationHeaderView", owner: self, options: nil)!.first as! UIView)
        addSubview(contentView)
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
