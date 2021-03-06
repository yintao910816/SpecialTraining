//
//  Video.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/17.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

//MARK:
//MARK: 点播
class OndemandModel: HJModel {
    var cate_list: [VideoCateListModel] = []
    var video_list: [VideoListModel] = []
}

class VideoCateListModel: HJModel {
    var id: String = ""
    var cate_name: String = ""
    
    var isSelected: Bool = false
    
    lazy var size: CGSize = {
        return .init(width: cate_name.getTexWidth(fontSize: 14, height: 20) + 20, height: 20)
    }()
    
    class func creatAllCateModel() ->VideoCateListModel {
        let m = VideoCateListModel()
        m.cate_name = "全部"
        return m
    }
}

class VideoListModel: HJModel {
    var id: String = ""
    var title: String = ""
    var cover_url: String = ""
    var cate_id: String = ""
    var video_url: String = ""
    
    lazy var size: CGSize = {
        let w: CGFloat = (PPScreenW - 1.0 - 7.0 * 3) / 2.0
        let h = w * 4.0/3.0
        return .init(width: w, height: h)
    }()
    
    class func transform(model: MyVidesModel) ->VideoListModel {
        let m = VideoListModel()
        m.id = model.id
        m.title = model.title
        m.cover_url = model.cover_url
        m.cate_id = model.cate_id
        m.video_url = model.video_url
        return m
    }
}
