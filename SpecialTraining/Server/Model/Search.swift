//
//  Search.swift
//  SpecialTraining
//
//  Created by yintao on 2019/2/25.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation

class SearchTypeModel: SearchDataAdapt {
    var cellIcon: UIImage?
    var cellTitleArr: NSAttributedString?
    
    class func creatModel(cellTitle: String) ->[SearchTypeModel]{
        let m = SearchTypeModel()
        m.cellIcon = UIImage.init(named: "search_course")
        var text = "搜索课程\(cellTitle)"
        m.cellTitleArr = text.attributed(.init(location: 4, length: cellTitle.count),
                                         RGB(212, 108, 52))
        
        let m1 = SearchTypeModel()
        m1.cellIcon = UIImage.init(named: "search_org")
        text = "搜索机构\(cellTitle)"
        m1.cellTitleArr = text.attributed(.init(location: 4, length: cellTitle.count),
                                         RGB(212, 108, 52))
        
        return [m, m1]
    }
}

protocol SearchDataAdapt {
    
}
