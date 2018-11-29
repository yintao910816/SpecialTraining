//
//  ObservableType+Extension.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/5/10.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    
    func _doNext(forWindow onWindow: Bool? = false,
                 forNotice notice: NoticesCenter,
                 forHint hint: String? = nil) ->Observable<E>{
        return self.do(onNext: { [weak notice] _ in
            onWindow == true ? notice?.loadingInWindow(hint) : notice?.noticeLoading(hint)
        })
    }
    
}
