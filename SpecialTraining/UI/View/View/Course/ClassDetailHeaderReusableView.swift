//
//  ClassDetailHeaderReusableView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/6/12.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class ClassDetailHeaderReusableView: UICollectionReusableView {
    @IBOutlet var contentView: UICollectionReusableView!
    @IBOutlet weak var carouselView: CarouselView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var classInfoOutlet: UILabel!
    @IBOutlet weak var suteOutlet: UILabel!
    @IBOutlet weak var createTimeOutlet: UILabel!
    @IBOutlet weak var bottomView: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("ClassDetailHeaderReusableView", owner: self, options: nil)?.first as! UICollectionReusableView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var model: CourseDetailClassModel! {
        didSet {
            titleOutlet.text = model.class_name
            let priceText = "¥\(model.price)"
            priceOutlet.attributedText = priceText.attributed(NSRange.init(location: 0, length: 1),
                                                              .red,
                                                              .systemFont(ofSize: 12))
            classInfoOutlet.text = model.class_days
            suteOutlet.text = model.suit_peoples
            createTimeOutlet.text = model.createtime
            
            carouselView.setData(source: ClassDetailCarouselModel.createData(source: [model.pic]), autoScroll: false)
        }
    }
}
