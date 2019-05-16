//
//  CourseClassSelectHeaderView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/17.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class CourseClassSelectHeaderView: UICollectionReusableView {

    @IBOutlet var contentView: UICollectionReusableView!
    @IBOutlet weak var sutePeoOutlet: UILabel!
    @IBOutlet weak var remindOutlet: UILabel!
    @IBOutlet weak var classNameOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var daysOutlet: UILabel!
    @IBOutlet weak var classTimeOutlet: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        contentView = (Bundle.main.loadNibNamed("CourseClassSelectHeaderView", owner: self, options: nil)?.first as! UICollectionReusableView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: CourseDetailClassModel! {
        didSet {
            classNameOutlet.text = model.class_name
            sutePeoOutlet.text = model.suit_peoples
            priceOutlet.text = "¥:\(model.price)"
            daysOutlet.text  = "\(model.class_days)天"
            classTimeOutlet.text = model.describe
        }
    }
    
    func viewHeight() ->CGFloat {
        setNeedsLayout()
        layoutIfNeeded()
        return remindOutlet.frame.maxY
    }
}
