//
//  UIView+XIB.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/6/12.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

extension UIView {

    public final func loadXIB(_ aclass: UIView.Type) ->UIView {
        let xibs = Bundle.main.loadNibNamed(stringFromClass(aclass), owner: self, options: nil)
        return (xibs?.first as! UIView)
    }
    
    private func stringFromClass(_ aclass: UIView.Type) ->String {
        return NSStringFromClass(aclass).replacingOccurrences(of: (Bundle.main.projectName + "."), with: "")
    }
}

extension UIView {
    
    public final func correctWidth(withWidth width: CGFloat = UIScreen.main.bounds.size.width) {
        var rect = frame
        rect.size.width = width
        frame = rect
    }
}
