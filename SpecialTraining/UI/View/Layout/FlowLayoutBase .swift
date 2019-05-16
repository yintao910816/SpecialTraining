//
//  BaseFlowLayout.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/6/7.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

class FlowLayoutBase: UICollectionViewFlowLayout {

    public weak var delegate: FlowLayoutBaseDelegate?
    // 边上的间距
    public var edgeInsets  = UIEdgeInsets.zero

    // item 之间Y轴上的间距
    public var lineSpacing: CGFloat = 0.0 {
        didSet{
            invalidateLayout()
        }
    }
    // item 之间X轴上的间距
    public var interSpacing: CGFloat = 0.0 {
        didSet{
            invalidateLayout()
        }
    }
}

extension FlowLayoutBase {
    
    /**
     计算 item 宽度
     */
    public func maxCurrentWidth(_ indexPath: IndexPath, _ fontSize: Float, _ height: CGFloat) ->CGFloat {
        let text: String? = delegate?.itemContent(layout: self, indexPath: indexPath) ?? ""
        return (text!.getTexWidth(fontSize: fontSize, height: height) + 2)
    }
    
    /**
     计算 item 高度
     */
    public func currentHeight(_ indexPath: IndexPath, _ width: CGFloat, _ fontSize: Float) -> CGFloat {
        let text: String? = delegate?.itemContent(layout: self, indexPath: indexPath) ?? ""
        return (text!.getTextHeigh(fontSize: fontSize, width: width) + 2)
    }
    
}

protocol FlowLayoutBaseDelegate: NSObjectProtocol {
    
    func itemContent(layout: FlowLayoutBase, indexPath: IndexPath) ->String
    
    /// 获取第一个section高度 - 只考虑一个section
    func size(forHeader inSection: Int) ->CGSize
    
}
