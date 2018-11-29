//
//  BaseFlowLayout.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/6/7.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

class BaseFlowLayout: UICollectionViewFlowLayout {

    public weak var delegate: FlowLayoutDelegate?
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

protocol FlowLayoutDelegate: NSObjectProtocol {
    
    func itemContent(layout: BaseFlowLayout, indexPath: IndexPath) ->CGSize
}
