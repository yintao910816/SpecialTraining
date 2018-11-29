//
//  FrameView.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/5/8.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

public enum FrameViewStyle {
    case black
    case white
    
    func color() -> UIColor {
        switch self {
        case .black:
            return UIColor.black
        case .white:
            return UIColor(white: 0.8, alpha: 0.36)
        }
    }
}

class FrameView: UIVisualEffectView {

    private var color: UIColor!
    
    internal init(_ style: FrameViewStyle) {
        super.init(effect: UIBlurEffect(style: .light))
        
        color = style.color()
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    fileprivate func commonInit() {
        backgroundColor     = color

        layer.cornerRadius  = 9.0
        layer.masksToBounds = true
        
        contentView.addSubview(self.content)
    }
    
    fileprivate var _content = UIView()
    internal var content: UIView {
        get {
            return _content
        }
        set {
            while (_content.subviews.count != 0) {
                _content.subviews.last?.removeFromSuperview()
            }
            _content       = newValue
            _content.alpha = 0.85
            _content.clipsToBounds = true
            PrintLog(_content)
            
            contentView.addSubview(_content)
        }
    }
        
}
