//
//  UIKit+Extension.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/5/8.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

extension NSObject {
    
    public var visibleViewController: UIViewController? {
        get {
            guard let rootVC = UIApplication.shared.delegate?.window??.rootViewController else{
                return nil
            }
            return getVisibleViewController(from: rootVC)
        }
    }
    
    private func getVisibleViewController(from: UIViewController?) ->UIViewController? {
        if let nav = from as? UINavigationController {
//            return getVisibleViewController(from:nav.visibleViewController)
            return getVisibleViewController(from:nav.viewControllers.last)
        }else if let tabBar = from as? UITabBarController {
            return getVisibleViewController(from: tabBar.selectedViewController)
        }else {
            guard let presentedVC = from?.presentedViewController else {
                return from
            }
            return getVisibleViewController(from: presentedVC)
        }
        
    }
    
}
