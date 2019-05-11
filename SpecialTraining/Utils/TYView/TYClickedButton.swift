//
//  PTClickedButton.swift
//  Potato
//
//  Created by sw on 09/04/2019.
//

import UIKit

class TYClickedButton: UIButton {
    
    private var ty_top: CGFloat = 10
    private var ty_bottom: CGFloat = 10
    private var ty_left: CGFloat = 10
    private var ty_right: CGFloat = 10

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        super.hitTest(point, with: event)
        
        let rect = self.enlargedRect()
        if isHidden == true || isUserInteractionEnabled == false || rect.equalTo(self.bounds){
            return super.hitTest(point, with: event)
        }else {
            if rect.contains(point) {
                print("PTClickedButton clicked")
                return self
            }else {
                return super.hitTest(point, with: event)
            }
        }
        
    }
    
    func setEnlargeEdge(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        ty_top = top
        ty_bottom = bottom
        ty_left = left
        ty_right = right
    }
    
    func enlargedRect() -> CGRect {
        if ty_top >= 0, ty_bottom >= 0, ty_left >= 0, ty_right >= 0 {
            let pointSize = CGRect.init(x: self.bounds.origin.x - CGFloat(ty_left),
                                        y: self.bounds.origin.y - CGFloat(ty_top),
                                        width: self.bounds.size.width + ty_left + ty_right,
                                        height: self.bounds.size.height + ty_top + ty_bottom)
            return pointSize
        }
        else {
            return self.bounds
        }
    }
}
