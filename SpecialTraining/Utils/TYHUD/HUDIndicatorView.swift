//
//  HUDSystemActivityIndicatorView.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/5/5.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

class HUDIndicatorView: TYIndicatorBaseView {

    init() {
        var rect = CGRect.zero
        rect.size = IndicatorSize.defaultSize
        super.init(frame: rect)
    }
   
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
