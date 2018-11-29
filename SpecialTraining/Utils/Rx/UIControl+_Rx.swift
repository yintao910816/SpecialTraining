//
//  UIControl+_Rx.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/4/18.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {
    
    public var backColor: Binder<UIColor> {
        return Binder(self.base) { control, value in
            control.backgroundColor = value
        }
    }
    
    public var enabled: Binder<Bool> {
        return Binder(self.base) { control, value in
            if value == true {
                control.backgroundColor = ST_MAIN_COLOR
                control.isUserInteractionEnabled = true
            }else {
                control.backgroundColor = .gray
                control.isUserInteractionEnabled = false
            }
        }
    }
    
//    func bgImage(_ strategy: ImageStrategy = .bookOriginal) -> Binder<String?> {
//        return Binder(self.base) { (button, url) -> () in
//            button.setImage(url, strategy)
//        }
//    }

}
