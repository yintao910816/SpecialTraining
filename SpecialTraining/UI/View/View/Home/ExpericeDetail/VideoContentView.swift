//
//  VideoContentView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/7/11.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class VideoContentView: UIScrollView {

    public var itemClick: ((CourseDetailVideoModel) ->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var videoDatas: [CourseDetailVideoModel]! {
        didSet {
            setupView()
        }
    }
    
    private func setupView() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        var idx: Int = 0
        for model in videoDatas {
            let videoItem = VideoItemView()
            videoItem.tag = 100 + idx
            videoItem.model = model
            addSubview(videoItem)
            
            videoItem.itemClick = { [unowned self] model in
                self.itemClick?(model)
            }
            
            idx += 1
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard videoDatas != nil else { return }
        guard videoDatas.count > 0 else { return }

        let itemWidth: CGFloat = height - 16
        let margin: CGFloat = 12
        
        var contentWidth: CGFloat = 0
        
        for idx in 0..<videoDatas.count {
            let itemView = viewWithTag(100 + idx)!
            let x = CGFloat(idx) * margin + itemWidth * CGFloat(idx)
            itemView.frame = .init(x: x, y: 0, width: itemWidth, height: height)
            
            contentWidth = itemView.frame.maxX
        }
        
        contentSize = .init(width: contentWidth, height: height)
    }
}
