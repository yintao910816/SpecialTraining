//
//  BaseModel.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/11/25.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation
import HandyJSON

class HJModel:NSObject ,HandyJSON {
    
    var total: Int = 0
    
    func mapping(mapper: HelpingMapper) {}
    
    required override init() {}
    
}

@objc protocol HomeCellSize {
    
    @objc optional var size: CGSize { get }
    
    
    @objc optional var sectionInset: UIEdgeInsets { get }
    
    
    @objc optional var minimumLineSpacing: CGFloat { get }

    @objc optional var minimumInteritemSpacing: CGFloat { get }
}
