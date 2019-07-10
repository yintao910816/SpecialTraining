//
//  VideoItemView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/7/11.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class VideoItemView: UIView {

    private var videoCover: UIImageView!
    private var videoTitle: UILabel!
    
    private var tapGes: UITapGestureRecognizer!
    
    public var itemClick: ((CourseDetailVideoModel) ->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        videoCover = UIImageView()
        videoCover.contentMode = .scaleAspectFill
        videoCover.clipsToBounds = true
        addSubview(videoCover)
        
        videoTitle = UILabel()
        videoTitle.font = UIFont.systemFont(ofSize: 13)
        videoTitle.textColor = RGB(68, 68, 68)
        addSubview(videoTitle)
        
        videoCover.snp.makeConstraints {
            $0.left.right.top.equalTo(0)
            $0.height.equalTo(videoCover.snp.width)
        }
        
        videoTitle.snp.makeConstraints {
            $0.top.equalTo(videoCover.snp.bottom).offset(5)
            $0.left.equalTo(2)
            $0.right.equalTo(2)
            $0.bottom.equalTo(0)
        }
        
        tapGes = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(tap:)))
        addGestureRecognizer(tapGes)
    }
    
    var model: CourseDetailVideoModel! {
        didSet {
            videoCover.setImage(model.res_image)
            videoTitle.text = model.res_title
        }
    }
    
    @objc private func tapAction(tap: UITapGestureRecognizer) {
        itemClick?(model)
    }
}
