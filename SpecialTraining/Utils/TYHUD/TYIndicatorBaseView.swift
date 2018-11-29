//
//  TYHUDSystemActivityIndicatorBaseView.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/5/5.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

open class TYIndicatorBaseView: UIView ,TYHUDAnimating{
    
    public  var loadingStatu = LoadingStatus.loading(text: nil)
    
    //MARK:
    //MARK: init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        commentInit()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commentInit()
    }
    
    private func commentInit() {
        backgroundColor = UIColor.white
        
        addSubview(indicatorView)
        addSubview(textLabel)
    }
    
    public var fontSize: CGFloat = 14.0 {
        didSet{
            textLabel.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    //MARK:
    //MARK: lazy load
    public let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
//        label.textColor = UIColor.black.withAlphaComponent(0.9)
        label.textColor = UIColor.black
        return label
    }()
    
    public let indicatorView: UIActivityIndicatorView = {
        /**
          whiteLarge 的尺寸是（37，37)
          White 的尺寸是（22，22)
         */
        let activity = UIActivityIndicatorView(style: .whiteLarge)
        activity.color = UIColor.black
        return activity
    }()

    //MARK:
    //MARK: PKHUDAnimating
    public func startAnimation() {
        if indicatorView.isAnimating == false { indicatorView.startAnimating() }
    }
    
    public func stopAnimation() {
        if indicatorView.isAnimating { indicatorView.stopAnimating() }
    }
    //MARK: 子类如果有特殊的功能 重写该方法并调用super
    //MARK:
    public func setStatue(statue: LoadingStatus) {
        loadingStatu   = statue
        textLabel.text = statue.hint()
        
        frame.size = frameSize()
        layoutIfNeeded()
    }
    
    //MARK: 子类如果有特殊的布局 重写该方法并调用super
    //MARK: layout
    open override func layoutSubviews() {
        super.layoutSubviews()

        switch loadingStatu {
        case .loading(let text):
            if indicatorView.superview == nil {
                addSubview(indicatorView)
            }
            if (text?.isEmpty == true || text == nil){
                indicatorView.center = center
            }else {
                indicatorView.origin = CGPoint.init(x: width/2.0 - IndicatorSize.whiteLargeSize/2.0, y: IndicatorSize.h_margin)
                textLabel.origin     = CGPoint.init(x: IndicatorSize.h_margin, y: indicatorView.frame.maxY + IndicatorSize.v_margin/2.0)
            }
            break
        case .success(let stext):
             layoutLabel(text: stext)
            break
        case .failure(let ftext):
            layoutLabel(text: ftext)
            break
        }
    }
    
    private func layoutLabel(text: String?) {
        indicatorView.stopAnimating()
        indicatorView.removeFromSuperview()

        textLabel.origin = CGPoint.init(x: IndicatorSize.h_margin, y: IndicatorSize.v_margin)
    }
}

fileprivate extension TYIndicatorBaseView {
    
    /// 计算整个HUD视图的 size
    ///
    /// - Returns: CGSize
    func frameSize() ->CGSize {
        switch loadingStatu {
        case .loading(let text):
            return frameForStatues(text, true)
        case .success(let text):
            return frameForStatues(text, false)
        case .failure(let text):
            return frameForStatues(text, false)
        }
    }
    
    private func frameForStatues(_ text: String?, _ indicator: Bool) ->CGSize {
        guard let hint = text else {
            textLabel.size = CGSize.zero
            return IndicatorSize.defaultSize
        }
        let font = UIFont.systemFont(ofSize: fontSize)
        let width = hint.textSize(font: font, width: CGFloat(MAXFLOAT), height: IndicatorSize.minTextHeight).width
        // 比最大文字宽度大
        if width > IndicatorSize.maxTextWidth {
            let height = hint.textSize(font: font, width: IndicatorSize.maxTextWidth, height: CGFloat(MAXFLOAT)).height
            textLabel.size = CGSize.init(width: IndicatorSize.maxTextWidth, height: height)
            return indicator == true ? CGSize.init(width: IndicatorSize.maxWidth,
                                                   height: IndicatorSize.defaultSize.height + height - IndicatorSize.minTextHeight)
                :
                CGSize.init(width: IndicatorSize.maxWidth,
                            height: height + 2*IndicatorSize.v_margin)
        }
        // 比最小文字宽度小
        if width <= IndicatorSize.minTextWidth  {
            if indicator {
                textLabel.size = CGSize.init(width: IndicatorSize.minTextWidth, height: IndicatorSize.minTextHeight)
                return IndicatorSize.defaultSize
            }else {
                textLabel.size = CGSize.init(width: width, height: IndicatorSize.minTextHeight)
                return CGSize.init(width: width + 2*IndicatorSize.h_margin, height: IndicatorSize.minTextHeight + 2*IndicatorSize.v_margin)
            }
        }
        // 在 最小文字宽度 和 最大文字宽度 之间
        textLabel.size = CGSize.init(width: width, height: IndicatorSize.minTextHeight)
        return indicator == true ? CGSize.init(width: width + 2*IndicatorSize.h_margin,
                                               height: IndicatorSize.defaultSize.height):
                                   CGSize.init(width: width + 2*IndicatorSize.h_margin,
                                               height: IndicatorSize.minTextHeight + 2*IndicatorSize.v_margin)
        
    }
}

public struct IndicatorSize {
    
    static let maxWidth: CGFloat       = UIScreen.main.bounds.size.width / 2.0

    static let v_margin: CGFloat       = 15.0
    
    static let h_margin: CGFloat       = 15.0
    
    static let minTextHeight: CGFloat  = 15.0
    
    static let whiteLargeSize: CGFloat = 37.0

    // 37 + 15 + 2*15 + v_margin / 2
    static private let size            = whiteLargeSize + minTextHeight + 2*v_margin + v_margin/2.0
    static let defaultSize             = CGSize.init(width: size, height: size)
    
    // label 最大宽度
    static let maxTextWidth: CGFloat   = maxWidth - 2*h_margin
    // label 最小宽度
    static let minTextWidth: CGFloat   = defaultSize.width - 2*h_margin
}
