//
//  NoticesCenter.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/5/8.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

class NoticesCenter { /**HUD*/

    private var noticeView = HUD.init(.indicator, .dark)
    
    init() { }
    
    public func noticeLoading(_ text: String? = nil, _ inView: UIView? = nil) {
        var hudView: UIView!
        if inView != nil {
            hudView = inView!
        }else {
            if let v = NSObject().visibleViewController?.view {
                hudView = v
            }else if let v = UIApplication.shared.keyWindow {
                hudView = v
            }else {
                return
            }
        }
        
        noticeView.showLoading(onView: hudView, forText: text)
    }
    
    public func loadingInWindow(_ text: String? = nil) {
        noticeView.showLoading(forText: text)
    }
    
    public func noticeHidden(_ completion: (()-> Void)? = nil) { noticeView.hidden(completion) }
    
    public func successHidden(_ text: String? = nil,  _ completion: (()-> Void)? = nil) {
        noticeView.hiddenSuccess(forText: text, forIntervar: 2, completion)
    }
    
    public func failureHidden(_ text: String? = nil, _ completion: (()-> Void)? = nil) {
        noticeView.hiddenFailure(forText: text, forIntervar: 2, completion)
    }
    
}

extension NoticesCenter { /**alert*/

    public static func alert(title         : String? = nil,
                             message       : String,
                             cancleTitle   : String? = nil,
                             okTitle       : String? = "确定",
                             presentCtrl   : UIViewController? = NSObject().visibleViewController,
                             callBackCancle: (() ->Void)? = nil,
                             callBackOK    : (() ->Void)? = nil) {
    
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
       
        let okAction = UIAlertAction.init(title: okTitle, style: .default) { _ in
            guard let callBack = callBackOK else{
                return
            }
            callBack()
        }
        alertVC.addAction(okAction)

        if cancleTitle?.isEmpty == false {
            let cancelAction = UIAlertAction.init(title: cancleTitle, style: .cancel) { _ in
                guard let callBack = callBackCancle else{
                    return
                }
                callBack()
            }
            alertVC.addAction(cancelAction)
        }
        
        presentCtrl?.present(alertVC, animated: true)
    }
    
    public static func alertActionSheet(title       : String? = nil,
                                        actionTitles  : [String],
                                        cancleTitle   : String? = nil,
                                        presentCtrl   : UIViewController? = NSObject().visibleViewController,
                                        callBackCancle: (() ->Void)? = nil,
                                        callBackChoose: ((Int) ->Void)? = nil) {
        
        let alertVC = UIAlertController.init(title: title, message: nil, preferredStyle: .actionSheet)
        
        for idx in 0..<actionTitles.count {
            let action = UIAlertAction.init(title: actionTitles[idx], style: .default) { t in
                guard let callBack = callBackChoose else{
                    return
                }
                callBack(idx)
            }
            
            alertVC.addAction(action)
        }
        
        if cancleTitle?.isEmpty == false {
            let cancelAction = UIAlertAction.init(title: cancleTitle!, style: .cancel) { _ in
                guard let callBack = callBackCancle else{
                    return
                }
                callBack()
            }
            alertVC.addAction(cancelAction)
        }
        
        presentCtrl?.present(alertVC, animated: true)
    }

    
}
