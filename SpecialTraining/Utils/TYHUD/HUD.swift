//
//  HUD.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/5/5.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

public enum HUDContentType {

    case indicator
}

public final class HUD {

    fileprivate let hudCtrl: TYHUD!
    
    init(_ content: HUDContentType, _ bgStyle: BgStyle) {
        hudCtrl = TYHUD.init(content, HUD.indicatorView(content), bgStyle)
    }
    
    public func showLoading(onView view: UIView? = nil, forText text: String? = nil) { hudCtrl.show(forStatue: LoadingStatus.loading(text: text), onView: view) }
    public func hiddenSuccess(forText text: String? = nil, forIntervar after: TimeInterval, _ completion: (()-> Void)?) {
        hudCtrl.hidden(forStatue: LoadingStatus.success(text: text), forIntervar: after, completion)
    }
    public func hiddenFailure(forText text: String? = nil, forIntervar after: TimeInterval, _ completion: (()-> Void)?) {
        hudCtrl.hidden(forStatue: LoadingStatus.failure(text: text), forIntervar: after, completion)
    }
        
    public func hidden(_ completion: (()-> Void)? = nil) { hudCtrl.hidden(completion) }
}

extension HUD {

    fileprivate static func indicatorView(_ content: HUDContentType) ->TYHUDAnimating {
        switch content {
        case .indicator:
            return HUDIndicatorView.init()
        }
    }

}
