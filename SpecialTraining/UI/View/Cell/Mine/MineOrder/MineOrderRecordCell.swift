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

    static let contentHeight: CGFloat = 136
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var coverOutlet: UIButton!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var detialOutlet: UILabel!
    @IBOutlet weak var remindOutlet: UILabel!
    @IBOutlet weak var rightOutlet: UIButton!
    @IBOutlet weak var leftOutlet: UIButton!
    
    weak var delegate: MineOrderRecordOperation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        coverOutlet.imageView?.contentMode = .scaleAspectFill
    }
    
    @IBAction func actions(_ sender: UIButton) {
        delegate?.orderOperation(statu: shopModel.statue, orderNum: orderModel.order_number)
    }
    
    var orderModel: OrderItemModel! {
        didSet {
            coverOutlet.setImage(orderModel.course_pic)
            
            titleOutlet.text = orderModel.course_name
            priceOutlet.text = orderModel.class_price
            detialOutlet.text = orderModel.class_name
            remindOutlet.text = "亲，请耐心等待为您安排具体班级"
        }
    }
    
    var shopModel: MemberAllOrderModel! {
        didSet {
            if shopModel.statue == .haspay {
                leftOutlet.isHidden = true
                rightOutlet.isHidden = false
                
                rightOutlet.setTitle("退款", for: .normal)
                setGrayLayer(button: rightOutlet)
            }else if shopModel.statue == .noPay {
                leftOutlet.isHidden = true
                rightOutlet.isHidden = false
                
                rightOutlet.setTitle("支付", for: .normal)
                setOrangeLayer(button: rightOutlet)
            }else if shopModel.statue == .packBack {
                leftOutlet.isHidden = false
                rightOutlet.isHidden = false
                
                rightOutlet.setTitle("取消退款", for: .normal)
                setGrayLayer(button: rightOutlet)
                
                leftOutlet.setTitle("退款中", for: .normal)
                setOrangeLayer(button: leftOutlet)
                leftOutlet.isUserInteractionEnabled = false
            }
        }
    }
    
    private func setGrayLayer(button: UIButton) {
        button.setTitleColor(RGB(130, 130, 130), for: .normal)
        
        button.layer.cornerRadius = button.height / 2.0
        button.layer.borderColor  = RGB(130, 130, 130).cgColor
        button.layer.borderWidth  = 1
    }
    
    private func setOrangeLayer(button: UIButton) {
        button.setTitleColor(RGB(212, 108, 52), for: .normal)

        button.layer.cornerRadius = button.height / 2.0
        button.layer.borderColor  = RGB(212, 108, 52).cgColor
        button.layer.borderWidth  = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.set(cornerRadius: 8, borderCorners: [.bottomLeft, .bottomRight])
    }
}

protocol MineOrderRecordOperation: class {
    func orderOperation(statu: OrderStatu, orderNum: String)
}
