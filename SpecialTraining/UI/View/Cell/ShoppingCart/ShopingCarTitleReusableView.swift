//
//  ShopingCarTitleReusableView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/1/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class ShopingCarTitleReusableView: UICollectionReusableView {

    @IBOutlet var contentView: UICollectionReusableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        set(cornerRadius: 6, borderCorners: [.topLeft, .topRight])

        contentView = (Bundle.main.loadNibNamed("ShopingCarTitleReusableView", owner: self, options: nil)?.first as! UICollectionReusableView)
        contentView.correctWidth(withWidth: width)
        addSubview(contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
