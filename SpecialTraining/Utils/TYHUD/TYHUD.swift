//
//  TYHUD.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/5/5.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

class TYHUD: NSObject{

    private let defaultLoadingTime: Double = 0.25
    
    fileprivate var onView : UIView = ((UIApplication.shared.delegate?.window)!)!
    fileprivate var content: HUDContentType
    fileprivate var indicator: TYHUDAnimating
    fileprivate var bgView   : BackgroundView
    
    fileprivate var timerWhenShow = Date.init()
    
    fileprivate var complement: (() ->Void)?
    fileprivate var loadingStatu: LoadingStatus!
    
    init(_ content: HUDContentType, _ indicator: TYHUDAnimating, _ bgStyle: BgStyle) {
        self.content   = content
        self.indicator = indicator
        bgView         = BackgroundView.init(frame: onView.bounds, style: bgStyle, content: indicator as! UIView)
    }
    
    @objc private func _hidden() {
        self.bgView.removeFromSuperview()
        self.indicator.stopAnimation()
        guard let cp = complement else {
            return
        }
        cp()
    }
    
    @objc private func _show() {
        show(forStatue: loadingStatu, onView: onView)
    }
    
    //MARK:
    //MARK: 控制 HUD 显 隐
    public func show(forStatue statue: LoadingStatus, onView view: UIView? = nil) {
        updateBg(view)
        
        indicator.setStatue(statue: statue)
        indicator.startAnimation()
        bgView.frameViewLayout()
    
        timerWhenShow = Date.init()
    }
    
    @objc public func hidden(_ completion: (()-> Void)? = nil) {
        let after = Date().timeIntervalSince(timerWhenShow)
        complement = completion
        if after < defaultLoadingTime {
            perform(#selector(_hidden), with: nil, afterDelay: (defaultLoadingTime - after))
        }else { _hidden() }
    }
    
    public func hidden(forStatue statue: LoadingStatus, forIntervar after: TimeInterval, _ completion: (()-> Void)?) {
        complement = completion
        loadingStatu = statue
        
        let _after = Date().timeIntervalSince(timerWhenShow)

        if statue.hint()?.isEmpty == true {
            perform(#selector(hidden(_:)), with: nil, afterDelay: after)
        }else {
            if _after < defaultLoadingTime {
                perform(#selector(_show), with: nil, afterDelay: (defaultLoadingTime - _after))
                perform(#selector(_hidden), with: nil, afterDelay: (defaultLoadingTime - _after + after))
            }else {
                self.show(forStatue: statue, onView: self.onView)
                perform(#selector(_hidden), with: nil, afterDelay: after)
            }
        }
    
    }
    
    //MARK:
    //MARK: 改变 bgView 的父视图和尺寸
    private func updateBg(_ onView: UIView?) {
        // 改变 bgView 的 superview
        if bgView.superview != onView {
            self.onView = (onView == nil ? ((UIApplication.shared.delegate?.window)!)! : onView!)
            
            bgView.removeFromSuperview()
            self.onView.addSubview(bgView)
        }else {
            if bgView.superview == nil { self.onView.addSubview(bgView) }
        }
        // 改变 bgView 的 frame
        if !bgView.frame.equalTo(self.onView.frame) {
            bgView.frame = self.onView.bounds
            bgView.layoutSubviews()
        }
    }
    
    deinit {
        PrintLog("- - - - - - > \(self) 释放了")
        complement = nil
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
}
