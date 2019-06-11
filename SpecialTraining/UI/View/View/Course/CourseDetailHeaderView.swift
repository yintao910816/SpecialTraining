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
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var moreChoseOutlet: UIButton!
    @IBOutlet weak var backOutlet: TYClickedButton!
    
    @IBOutlet weak var backTopCns: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView = (Bundle.main.loadNibNamed("CourseDetailHeaderView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        backTopCns.constant += LayoutSize.fitTopArea
        
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    var model: CourseDetailInfoModel! {
        didSet {
            carouselView.setData(source: CourseDetailHeaderCarouselModel.creatData(sources: model.pic_list))
            titleOutlet.text = model.type_name
            let priceText = "¥\(model.about_price)"
            priceOutlet.attributedText = priceText.attributed(NSRange.init(location: 0, length: 1),
                                                              .red,
                                                              .systemFont(ofSize: 12))
        }
    }
    
    var picList: [CourseDetailClassModel] = [] {
        didSet {
            var maxIdx: Int = 0
            for idx in 0..<picList.count {
                let imgV = (viewWithTag(100 + idx) as? UIImageView)
                imgV?.setImage(picList[idx].pic)
                imgV?.isHidden = false
                
                maxIdx = idx
            }

            maxIdx += 1
            if maxIdx < 3 {
                for idx in maxIdx..<3 {
                    let imgV = (viewWithTag(100 + idx) as? UIImageView)
                    imgV?.isHidden = true
                }
            }
        }
    }
}
