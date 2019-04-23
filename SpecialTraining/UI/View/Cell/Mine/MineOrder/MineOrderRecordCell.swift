//
//  MineOrderRecordCell.swift
//  SpecialTraining
//
//  Created by sw on 21/04/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

typealias OrderStatu = MemberAllOrderModel.OrderStatu

class MineOrderRecordCell: UICollectionViewCell {

    static let contentHeight: CGFloat = 105
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var coverOutlet: UIButton!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var detialOutlet: UILabel!
    @IBOutlet weak var remindOutlet: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        coverOutlet.imageView?.contentMode = .scaleAspectFill
    }
        
    var orderModel: OrderItemModel! {
        didSet {
            coverOutlet.setImage(orderModel.course_pic)
            
            titleOutlet.text = orderModel.course_name
            priceOutlet.text = "¥\(orderModel.class_price)"
            detialOutlet.text = orderModel.class_name
            remindOutlet.text = "亲，请耐心等待为您安排具体班级"
        }
    }
}
