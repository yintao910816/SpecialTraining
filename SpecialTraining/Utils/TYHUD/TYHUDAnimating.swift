//
//  PKHUDAnimating.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/5/5.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation

public protocol TYHUDAnimating {
    
    func startAnimation()

    func stopAnimation()
    
    func setStatue(statue: LoadingStatus)

}

public enum LoadingStatus {
    case loading(text: String?)
    case success(text: String?)
    case failure(text: String?)
}

extension LoadingStatus {
    func hint() -> String? {
        switch self {
        case .loading(let text):
            return text
        case .success(let text):
            return text
        case .failure(let text):
            return text
        }
    }
}
