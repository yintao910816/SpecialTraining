//
//  CourseDetailInfoView.swift
//  SpecialTraining
//
//  Created by sw on 10/06/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxSwift

class CourseDetailInfoView: UIView {
    
    private let disposeBag = DisposeBag()
    private var webView: UIWebView!
    
    public let animotionHeaderSubject = PublishSubject<Bool>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        webView = UIWebView()
        webView.scrollView.isDirectionalLockEnabled = true
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        addSubview(webView)
        
        webView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
        
        webView.scrollView.rx.didScroll.asDriver()
            .drive(onNext: { [unowned self] in
                let point = self.webView.scrollView.panGestureRecognizer.translation(in: self)
                if point.y > 0
                {
                    // 向下滚动
                    if self.webView.scrollView.contentOffset.y < 44 { self.animotionHeaderSubject.onNext(false) }
                }else {
                    // 向上滚动
                    if self.webView.scrollView.contentOffset.y > 0 { self.animotionHeaderSubject.onNext(true) }
                }
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var model: CourseDetailInfoModel? {
        didSet {
            guard let _model = model else { return }
            if let requestUrl = APIAssistance.courseDetailH5URL(courseId: _model.course_id) {
                let request = URLRequest.init(url: requestUrl)
                webView.loadRequest(request)
            }
        }
    }
}
