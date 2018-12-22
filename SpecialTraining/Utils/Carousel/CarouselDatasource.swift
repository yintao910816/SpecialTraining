//
//  CarouselDatasource.swift
//  ComicsReader
//
//  Created by 尹涛 on 2018/5/22.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

enum TypePage {
    case last
    case current
    case next
}

class CarouselDatasource {
    
    // 被扩充后数据的倍数
    private var multiple: Int = 20
    // 当前page
    private var indexCurrentImage: Int = 0
    // 总共page
    private var pageCount: Int = 0
            
    var dataSource: [CarouselSource]! {
        didSet {
            pageCount = dataSource.count
            indexCurrentImage = 0
        }
    }
    
    private func getNextIndexImage(indexOfCurrentImage index: Int) ->Int {
        let tempIndex = index + 1
        return tempIndex < dataSource.count ? tempIndex : 0
    }
    
    private func getLastIndexImage(indexOfCurrentImage index: Int) ->Int {
        let tempIndex = index - 1
        return tempIndex >= 0 ? tempIndex : dataSource.count - 1
    }
    
    //MARK:
    /**
     * 获取每个item绑定的数据
     */
    func itemModel(_ typePage: TypePage = .current) ->CarouselSource? {
        switch typePage {
        case .current:
            return dataSource[indexCurrentImage]
        case .last:
            return dataSource[getLastIndexImage(indexOfCurrentImage: indexCurrentImage)]
        case .next:
            return dataSource[getNextIndexImage(indexOfCurrentImage: indexCurrentImage)]
        }
    }
    
    /** 滚动结束设置当前页码
     * distance: scroll的偏移量
     */
    func scrollEnd(scroll: UIScrollView, indicatorCallBack: (Int) ->Void) {
        let offset = scroll.contentOffset.x
        if offset == 0 {
            indexCurrentImage = getLastIndexImage(indexOfCurrentImage: indexCurrentImage)
        }else if offset == scroll.width * 2 {
            indexCurrentImage = getNextIndexImage(indexOfCurrentImage: indexCurrentImage)
        }
        indicatorCallBack(indexCurrentImage)
    }
    
}

//MARK:
//MARK: 轮播图数据模型必须遵循此协议
protocol CarouselSource {
    
    /**
     *  加载网络图片时的url地址
     */
    var url: String? { get }
    /**
     * 加载本地图片的图片名字
     */
    var name: String? { get }
}

extension CarouselSource {
    
    var name: String? {
        return nil
    }
    
    var url: String? {
        return nil
    }

}
