//
//  EmojViewFlowLayout.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/5/12.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

class EmojViewFlowLayout: UICollectionViewFlowLayout {

    private var attributeArray     = [UICollectionViewLayoutAttributes]()
    private var nextItemX: CGFloat = 0.0
    private var nextRow            = 0
    private var createdItemNum     = 0
    //MARK:
    //MARK: 属性设置
    var rowsCount: Int = 0 {
        didSet {
            invalidateLayout()
        }
    }
    
    var sectionNum: Int = 0 {
        didSet {
            invalidateLayout()
        }
    }

    var countInRow: Int = 0 {
        didSet {
            invalidateLayout()
        }
    }

    var lineSpacing: CGFloat = 0.0 {
        didSet {
            invalidateLayout()
        }
    }

    var interitemSpacing: CGFloat = 0.0 {
        didSet {
            invalidateLayout()
        }
    }

    var emojItemSize: CGSize = CGSize.zero {
        didSet {
            invalidateLayout()
        }
    }

    var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            invalidateLayout()
        }
    }

    //MARK:
    //MARK: <##>
    override func prepare() {
        super.prepare()
        
        attributeArray.removeAll()
        //拿到每个分区所有item的个数
        for section in 0 ..< sectionNum {
            let totalItems = collectionView?.numberOfItems(inSection: section) ?? 0
            for row in 0 ..< totalItems {
                let indexPath = IndexPath.init(row: row, section: section)
                let frame = setLayoutAttributes(section, row)
                
                let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
                attribute.frame = frame
                attributeArray.append(attribute)
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var resultArray = [UICollectionViewLayoutAttributes]()
        for attributes in attributeArray {
            let rect1 = attributes.frame
            if rect1.intersects(rect) {
                resultArray.append(attributes)
            }
        }
        return resultArray
    }
    
    override var collectionViewContentSize: CGSize {
        let height = collectionView?.frame.height ?? 0
        return CGSize.init(width: (collectionView?.frame.size.width ?? 0) * CGFloat(sectionNum), height: height)
    }
    
    //MARK:
    //MARK: <##>
    private func setLayoutAttributes(_ section: Int, _ row: Int) ->CGRect {
        let xCount = row % countInRow
        let yCount = row / countInRow

        var xPos = (collectionView?.frame.width ?? 0.0) * CGFloat(section) + edgeInsets.left + CGFloat(xCount) * emojItemSize.width
        xPos += CGFloat(xCount) * interitemSpacing
        
        var yPos = edgeInsets.top + CGFloat(yCount) * emojItemSize.height
        yPos += CGFloat(yCount + 1) * lineSpacing + edgeInsets.bottom

        return CGRect.init(x: xPos, y: yPos, width: emojItemSize.width, height: emojItemSize.height)
    }
    
}
