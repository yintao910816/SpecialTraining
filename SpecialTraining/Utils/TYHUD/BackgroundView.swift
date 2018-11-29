//
//  BackgroundView.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/5/5.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

public enum BgStyle {
    case dark
    case white
    case clear
}

extension BgStyle {

    public func color() ->UIColor {
        switch self {
        case .dark:
            return UIColor.init(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 0.2)
        case .white:
            return UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 0.2)
        case .clear:
            return UIColor.init(white: 1, alpha: 0)
        }
    }
    
    public func frameStyle() ->FrameViewStyle {
        switch self {
        case .dark:
            return .white
        case .white, .clear:
            return .black
        }
    }
}

class BackgroundView: UIView {
    
    fileprivate var frameView: FrameView!
    fileprivate var content: UIView!

    init(frame: CGRect, style: BgStyle, content: UIView) {
        super.init(frame: frame)
        backgroundColor = style.color()

        frameView = FrameView.init(style.frameStyle())
        self.content         = content
        frameView.content    = self.content
        frameView.frame.size = content.bounds.size
        addSubview(frameView)
    }
    
    public func frameViewLayout() { frameView.frame.size = content.bounds.size }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSubview(frameView)
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        
        frameView.center = center
    }
    
    deinit{
        frameView.removeFromSuperview()
        removeFromSuperview()
    }

}
