//
//  ExpericeCourseDetailHeaderView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/6/29.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxSwift

class ExpericeCourseDetailHeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var carouselView: CarouselView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var classInfoOutlet: UILabel!
    @IBOutlet weak var sutePeoOutlet: UILabel!
    @IBOutlet weak var sepLine: UIView!
    
    private var videoContentView: VideoContentView!

    public let courseInfoObser = Variable(CourseDetailModel())
    public let contentHeightObser = PublishSubject<CGFloat>()
    public let videoPlaySubject = PublishSubject<CourseDetailVideoModel>()

    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("ExpericeCourseDetailHeaderView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
        
        videoContentView = VideoContentView()
        addSubview(videoContentView)
        videoContentView.itemClick = { [unowned self] model in self.videoPlaySubject.onNext(model) }

        videoContentView.snp.makeConstraints {
            $0.top.equalTo(sepLine.snp.bottom).offset(8)
            $0.left.equalTo(snp.left).offset(12)
            $0.right.equalTo(snp.right).offset(-12)
            $0.height.equalTo(120)
        }
        
        courseInfoObser.asDriver()
            .skip(1)
            .drive(onNext: { [weak self] data in
                guard let strongSelf = self else { return }
                strongSelf.carouselView.setData(source: PhotoModel.creatPhotoModels(photoList: data.course_info.pic_list))
                strongSelf.titleOutlet.text = data.course_info.title
                strongSelf.priceOutlet.text = "¥: \(data.course_info.about_price)"
                
                strongSelf.classInfoOutlet.text = "上课信息：\(data.classList.first?.class_days ?? "0")节"
                strongSelf.sutePeoOutlet.text = "适合人群：\(data.classList.first?.suit_peoples ?? "")"
                
                strongSelf.setVideoView(model: data)
            })
            .disposed(by: disposeBag)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setVideoView(model: CourseDetailModel) {
        if model.videoList.count > 0 {
//            let dataArr = model.videoList.count > 3 ? Array(model.videoList[0...2]) : model.videoList
//            for idx in 0..<dataArr.count {
//                let videoCover = (viewWithTag(300 + idx) as! UIButton)
//                videoCover.imageView?.contentMode = .scaleAspectFill
//                videoCover.isHidden = false
//                let videoLable = (viewWithTag(400 + idx) as! UILabel)
//                videoLable.isHidden = false
//                videoCover.setImage(dataArr[idx].res_image)
//                videoLable.text = dataArr[idx].res_title
//            }
            videoContentView.videoDatas = model.videoList
            setNeedsLayout()
            layoutIfNeeded()
            
            contentHeightObser.onNext(videoContentView.frame.maxY)
        }else {
            setNeedsLayout()
            layoutIfNeeded()
            contentHeightObser.onNext(sepLine.frame.maxY)
        }
    }

}
