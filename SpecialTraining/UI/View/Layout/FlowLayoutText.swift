//
//  SearchFlowLayout.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/3/21.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation

class FlowLayoutText: FlowLayoutBase {
    
    private var lastFrame: CGRect = .zero
    private var attributeArray    = [UICollectionViewLayoutAttributes]()
    
    public var font: Float = 15.0
        
    //MARK
    //MARK: paramter
    public var itemMinHeight: CGFloat = 0.0 {
        didSet{
            invalidateLayout()
        }
    }
    
    //MARK
    //MARK: layout
    override func prepare() {
        super.prepare()
        
        attributeArray.removeAll()
        // 总宽度
        let totalWidth = collectionView?.bounds.size.width ?? 0
        // item 总宽度
        let itemWidth = (totalWidth - edgeInsets.left - edgeInsets.right)
        // 拿到每个分区所有item的个数
        if (collectionView?.numberOfSections ?? 0) <= 0 { return }
        let totalItems = collectionView?.numberOfItems(inSection: 0) ?? 0
        
        // 只考虑一个section
        let layoutHeader = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                                                 with: IndexPath.init(row: 0, section: 0))
        layoutHeader.frame = .init(origin: .zero, size: delegate?.size(forHeader: 0) ?? .zero)
        attributeArray.append(layoutHeader)

        lastFrame = CGRect.init(x: 0, y: edgeInsets.top, width: layoutHeader.frame.width, height: layoutHeader.frame.height)

        for index in 0..<totalItems {
            var frame = CGRect.zero
            let indexPath = IndexPath.init(row: index, section: 0)
            
            let width = maxCurrentWidth(indexPath)
            if width > itemWidth {
                // 超过最大宽度，直接换行，计算行高
                frame = CGRect.init(x: edgeInsets.left, y: lastFrame.maxY + lineSpacing, width: itemWidth, height: currentHeight(indexPath))
            }else {

                if (lastFrame.maxX + interSpacing + width + edgeInsets.right) > totalWidth {
                    // 不能接在前一个后面，要换行
                    frame = CGRect.init(x: edgeInsets.left, y: lastFrame.maxY + lineSpacing, width: width, height: itemMinHeight)
                }else {
                    frame = CGRect.init(x: lastFrame.maxX + interSpacing, y: lastFrame.origin.y, width: width, height: itemMinHeight)
                }
            }
            
            let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
            attribute.frame = frame
            attributeArray.append(attribute)
            
            lastFrame = frame
        }
        
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var resultArray = [UICollectionViewLayoutAttributes]()
        
        for attributes in attributeArray {
            let rect1 = attributes.frame
            if rect.intersects(rect1) {
                resultArray.append(attributes)
            }
        }
        
        return resultArray
    }
    
}

extension FlowLayoutText {

    /**
     计算 item 宽度
     */
    fileprivate func maxCurrentWidth(_ indexPath: IndexPath) ->CGFloat {
        let text: String? = delegate?.itemContent(layout: self, indexPath: indexPath) ?? ""
        return (text!.getTexWidth(fontSize: font, height: itemMinHeight - 2*5) + 2*5)
    }
    
    /**
     计算 item 高度
     */
    fileprivate func currentHeight(_ indexPath: IndexPath) -> CGFloat {
        let text: String? = delegate?.itemContent(layout: self, indexPath: indexPath) ?? ""
        let layoutW = (collectionView?.width ?? 0) - edgeInsets.left - edgeInsets.right - CGFloat(2*5)
        var h = text!.getTextHeigh(fontSize: font, width: layoutW)
        h += CGFloat(2*5)
        return h
    }

}


