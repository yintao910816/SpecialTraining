//
//  ShoppingVerifyReusableView.swift
//  SpecialTraining
//
//  Created by sw on 11/01/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class ShoppingVerifyReusableView: UICollectionReusableView {

    @IBOutlet var contentView: UICollectionReusableView!
    
    @IBOutlet weak var dianpuOutlet: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        contentView = (Bundle.main.loadNibNamed("ShoppingVerifyReusableView", owner: self, options: nil)?.first as! UICollectionReusableView)
        contentView.correctWidth(withWidth: width)
        addSubview(contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var model: CourseDetailClassModel! {
        didSet {
            dianpuOutlet.text = model.shop_name
        }
    }
}
