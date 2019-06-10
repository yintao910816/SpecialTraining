//
//  CourseDetailHeaderView.swift
//  SpecialTraining
//
//  Created by sw on 10/06/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class CourseDetailHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var carouselView: CarouselView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView = (Bundle.main.loadNibNamed("CourseDetailHeaderView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    var datas: [CourseDetailHeaderCarouselModel]! {
        didSet {
            carouselView.setData(source: datas)
        }
    }
}
