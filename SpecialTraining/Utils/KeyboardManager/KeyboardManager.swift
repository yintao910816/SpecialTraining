//
//  KeyboardManager.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/6/14.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class KeyboardManager: NSObject {
    
    fileprivate var moveView : UIView!
    fileprivate var subviewFrame: CGRect!
    fileprivate var superview: UIView!
    
    public final func registerNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardHidden(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

    }
    
    public final func removeNotification() {
        NotificationCenter.default.removeObserver(self)
        PrintLog("注册的键盘通知移除了")
    }
    
    /*!
     @brief 键盘出现调整界面
     @param coverView 被盖住的视图
     @param fitView   需要移动的视图
     */
    public func move(coverView: UIView, moveView: UIView) {
        setup(coverView.superview!, coverView.frame, moveView)
    }
    
    //MARK:
    //MARK: private
    fileprivate func setup(_ superview: UIView, _ subviewFrame: CGRect, _ moveView: UIView) {
        self.superview    = superview
        self.subviewFrame = subviewFrame
        self.moveView     = moveView
    }
    
    @objc func keyboardShow(_ no: Notification) {
        let userInfo = no.userInfo!
        let kbEndRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let options = UIView.AnimationOptions(rawValue: UInt((userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
        viewTransform(options, duration, kbEndRect)
    }
    
    @objc func keyboardHidden(_ no: Notification) {
        let userInfo = no.userInfo!
        let options  = UIView.AnimationOptions(rawValue: UInt((userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue

        viewTransformIdentity(options, duration)
    }
    
    
    deinit {
        removeNotification()
    }

 }

extension KeyboardManager { /** 视图移动 */

    fileprivate func viewTransform(_ options: UIView.AnimationOptions, _ duration: Double, _ endKbRect: CGRect) {
        var newpoint = CGPoint.zero
        if superview.isKind(of: UITableView.self) == true {
            newpoint = subviewFrame.origin
        }else {
            newpoint = superview.convert(subviewFrame.origin, to: UIApplication.shared.delegate?.window!)
        }
        
        let subviewMaxY = newpoint.y + subviewFrame.size.height //- moveView.transform.ty
        
        if subviewMaxY >= endKbRect.origin.y {
            
            let animations:(() -> Void) = {
                self.moveView.transform = CGAffineTransform(translationX: 0, y: -(subviewMaxY - endKbRect.origin.y))
            }
            
            if duration > 0 {
                UIView.animate(withDuration: duration, delay: 0, options: options, animations: animations, completion: nil)
            }else { animations() }
        }else {
            
        }
    }
    
    fileprivate func viewTransformIdentity(_ options: UIView.AnimationOptions, _ duration: Double) {
        if moveView != nil {
            if moveView.transform.ty != 0 {
                UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                    self.moveView.transform = CGAffineTransform.identity
                }, completion: nil)
            }            
        }
    }
    
}

