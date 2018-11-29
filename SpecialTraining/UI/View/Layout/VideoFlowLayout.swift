//
//  SearchFlowLayout.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/3/21.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

class VideoFlowLayout: BaseFlowLayout {

    private var attributeArray    = [UICollectionViewLayoutAttributes]()
    
    //
    var lastDualNumberY: CGFloat = 0
    var lastSingularY: CGFloat = 0
    
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
        
        lastDualNumberY = edgeInsets.top
        lastSingularY = edgeInsets.top
        
        // 总宽度
        let totalWidth = collectionView?.bounds.size.width ?? 0
        // item 总宽度
        let itemWidth = (totalWidth - edgeInsets.left - edgeInsets.right - interSpacing) / 2.0
        // 拿到每个分区所有item的个数
        let totalItems = collectionView?.numberOfItems(inSection: 0) ?? 0
        
        for index in 0..<totalItems {
            var frame = CGRect.zero
            let indexPath = IndexPath.init(row: index, section: 0)

            let height = currentHeight(indexPath, itemWidth: itemWidth)
            if index % 2 == 0 {
                frame.origin = .init(x: edgeInsets.left, y: lastDualNumberY)
                
                lastDualNumberY += (height + lineSpacing)
            }else {
                frame.origin = .init(x: edgeInsets.left + itemWidth + interSpacing, y: lastSingularY)
                
                lastSingularY += (height + lineSpacing)
            }

            frame.size = .init(width: itemWidth, height: height)
            
            let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
            attribute.frame = frame
            attributeArray.append(attribute)
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
    
    override var collectionViewContentSize: CGSize {
        
        guard let width = collectionView?.width else {
            return .zero
        }
        
        if attributeArray.count == 1 {
            return .init(width: width, height: attributeArray[0].frame.maxY + edgeInsets.bottom)
        }else if attributeArray.count >= 2 {
            if let lastItemFrame = attributeArray.last?.frame{
                let lastSecondItemFrame = attributeArray[attributeArray.count - 2].frame
                let maxHeight = max(lastItemFrame.maxY, lastSecondItemFrame.maxY)
                return .init(width: width, height: maxHeight + edgeInsets.bottom)
            }
        }
        
        return .zero
    }
}

extension VideoFlowLayout {
    
    /**
     计算 item 高度
     */
    fileprivate func currentHeight(_ indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        if let curSize = delegate?.itemContent(layout: self, indexPath: indexPath) {
            return itemWidth * curSize.height / curSize.width
        }
        return 0
    }

}


