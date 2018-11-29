//
//  BaseCourse.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class BaseCourseModel: HJModel {
    
}

extension BaseCourseModel: HomeCellSize {
        
    var sectionInset: UIEdgeInsets {
        get {
            return .init(top: 0, left: 10, bottom: 10, right: 10)
        }
    }
    
    var minimumInteritemSpacing: CGFloat {
        get {
            return 12
        }
    }
    
    var minimumLineSpacing: CGFloat {
        get {
            return 13
        }
    }

}
