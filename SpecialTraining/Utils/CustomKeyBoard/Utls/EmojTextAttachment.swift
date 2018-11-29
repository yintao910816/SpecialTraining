//
//  EmojTextAttachment.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/5/12.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

class EmojTextAttachment: NSTextAttachment {

    public var emojiTag : String!
    public var emojiSize: CGSize!
    public var topInset : CGFloat!
    
    /// 自定义构造方法
    ///
    /// - Parameters:
    ///   - emojiTag: emoji图片tag，获取全部字符串时emoji图片会显示tag值
    ///   - emojiSize: emoji图片size
    ///   - topInset: emoji顶部偏移量
    init(_ emojiTag: String, _ emojiSize: CGSize, _ topInset: CGFloat) {
        super.init(data: nil, ofType: nil)
        self.emojiTag  = emojiTag
        self.emojiSize = emojiSize
        self.topInset  = topInset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func attachmentBounds(for textContainer: NSTextContainer?,
                                   proposedLineFragment lineFrag: CGRect,
                                   glyphPosition position: CGPoint,
                                   characterIndex charIndex: Int) -> CGRect {
        
        return CGRect.init(x: 0, y: self.topInset, width: self.emojiSize.width, height: self.emojiSize.height)
    }

}
