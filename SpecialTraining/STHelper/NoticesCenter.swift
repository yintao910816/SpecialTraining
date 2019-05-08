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
                             isCustom      : Bool = false,
                             presentCtrl   : UIViewController? = NSObject().visibleViewController,
                             
                             callBackCancle: (() ->Void)? = nil,
                             callBackOK    : (() ->Void)? = nil) {
    
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
       
        if isCustom == true, message.count > 0 {
            let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            paragraphStyle.headIndent = 14
            
            let messageText = NSMutableAttributedString(
                string: message,
                attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                    NSAttributedString.Key.foregroundColor: UIColor.black
                ]
            )
            
            alertVC.setValue(messageText, forKey: "attributedMessage")
        }

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

extension UIAlertController {
    
    /**
     - (NSArray *)viewArray:(UIView *)root {
     NSLog(@"%@", root.subviews);
     static NSArray *_subviews = nil;
     _subviews = nil;
     for (UIView *v in root.subviews) {
     if (_subviews) {
     break;
     }
     if ([v isKindOfClass:[UILabel class]]) {
     _subviews = root.subviews;
     return _subviews;
     }
     [self viewArray:v];
     }
     return _subviews;
     }
     
     - (UILabel *)titleLabel {
     return [self viewArray:self.view][0];
     }
     
     - (UILabel *)messageLabel {
     return [self viewArray:self.view][1];
     }

     */
    
//    func viewArray(rootView: UIView) ->[UIView] {
//        var _subViews = [UIView]()
//        for view in rootView.subviews {
//            if view.isKind(of: UILabel.self) {
//                _subViews = rootView.subviews
//                return _subViews
//            }
//        }
//        return _subViews
//    }

}
