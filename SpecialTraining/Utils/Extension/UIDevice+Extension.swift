//
//  UIDevice+Extension.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/11/9.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    
    /**
     判断是否为刘海屏
     */
    public var isX: Bool {
        if #available(iOS 11, *) {
            guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else { return false }
            
            if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
                return true
            }
        }
        return false
    }
}
