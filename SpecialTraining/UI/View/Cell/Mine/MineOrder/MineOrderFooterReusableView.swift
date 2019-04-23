


//
//  MineOrderFooterReusableView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/4/23.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

typealias MineOrderFooterOpType = MineOrderFooterReusableView.OperationType

class MineOrderFooterReusableView: UICollectionReusableView {
    
    enum OperationType {
        case cancleOrder
        case goPay
        case payBack
        case inPayBack
        case canclePayBack
    }

    static let contentHeight: CGFloat = 105

    @IBOutlet var contentView: UICollectionReusableView!
    @IBOutlet weak var cornerBgOutlet: UIView!
    
    @IBOutlet weak var rightOutlet: UIButton!
    @IBOutlet weak var leftOutlet: UIButton!

    weak var delegate: MineOrderRecordOperation?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = (Bundle.main.loadNibNamed("MineOrderFooterReusableView", owner: self, options: nil)?.first as! UICollectionReusableView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func actions(_ sender: UIButton) {
        var type: MineOrderFooterOpType!
        if sender == leftOutlet {
            if shopModel.statue == .noPay {
                type = .cancleOrder
            }else if shopModel.statue == .packBack {
                type = .inPayBack
            }
        }else if sender == rightOutlet {
            if shopModel.statue == .noPay {
                type = .goPay
            }else if shopModel.statue == .haspay {
                type = .payBack
            }else if shopModel.statue == .packBack {
                type = .canclePayBack
            }
        }
        delegate?.orderOperation(orderNum: shopModel.order_number, operationType: type)
    }
    
    var shopModel: MemberAllOrderModel! {
        didSet {
            if shopModel.statue == .haspay {
                leftOutlet.isHidden = true
                rightOutlet.isHidden = false
                
                rightOutlet.setTitle("退款", for: .normal)
                setGrayLayer(button: rightOutlet)
            }else if shopModel.statue == .noPay {
                leftOutlet.isHidden = false
                rightOutlet.isHidden = false

                leftOutlet.setTitle("取消订单", for: .normal)
                setGrayLayer(button: leftOutlet)

                rightOutlet.setTitle("付款", for: .normal)
                setOrangeLayer(button: rightOutlet)
            }else if shopModel.statue == .packBack {
                leftOutlet.isHidden = false
                rightOutlet.isHidden = false
                
                rightOutlet.setTitle("取消退款", for: .normal)
                setGrayLayer(button: rightOutlet)
                
                leftOutlet.setTitle("退款中", for: .normal)
                setOrangeLayer(button: leftOutlet)
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
        
//        cornerBgOutlet.set(cornerRadius: 8, borderCorners: [.bottomLeft, .bottomRight])
    }
}

protocol MineOrderRecordOperation: class {
    func orderOperation(orderNum: String, operationType: MineOrderFooterOpType)
}
