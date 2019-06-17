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
    var webView: UIWebView!
    
    public let animotionHeaderSubject = PublishSubject<CGFloat>()
    /// 可以滚动header的最小contentSize高度
    public var scrollMinContentHeight: CGFloat = 0

    public let contentSizeObser = PublishSubject<CGSize>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        webView = UIWebView()
        webView.scrollView.bounces = false
        webView.scrollView.isDirectionalLockEnabled = true
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.delegate = self
        addSubview(webView)
        
        webView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
        
//        webView.scrollView.rx.didScroll.asDriver()
//            .drive(onNext: { [unowned self] in
//                let point = self.webView.scrollView.panGestureRecognizer.translation(in: self)
//                if point.y > 0
//                {
//                    // 向下滚动
//                    if self.webView.scrollView.contentOffset.y < 44 { self.animotionHeaderSubject.onNext(false) }
//                }else {
//                    // 向上滚动
//                    if self.webView.scrollView.contentOffset.y >= 0 && self.webView.scrollView.contentSize.height > self.scrollMinContentHeight
//                    {
//                        self.animotionHeaderSubject.onNext(true)
//                    }
//                }
//            })
//            .disposed(by: disposeBag)

        webView.scrollView.rx.didScroll.asDriver().map{ [unowned self] in self.webView.scrollView.contentOffset.y }
            .drive(animotionHeaderSubject)
            .disposed(by: disposeBag)

//        webView.scrollView.rx
//            .observeWeakly(CGSize.self, "contentSize")
//            .bind(to: contentSizeObser)
//            .disposed(by: disposeBag)
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

extension CourseDetailInfoView: AdaptScrollAnimotion {
    var scrollContentOffsetY: CGFloat { return webView.scrollView.contentOffset.y }
    
    func canAnimotion(offset y: CGFloat) -> Bool {
        return webView.scrollView.contentSize.height >= y
    }
    
    func scrollMax(contentOffset y: CGFloat) {
        if webView.scrollView.contentSize.height >= y {
            webView.scrollView.setContentOffset(.init(x: 0, y: y), animated: false)
        }else {
            webView.scrollView.setContentOffset(.init(x: 0, y: webView.scrollView.contentOffset.y), animated: true)
            animotionHeaderSubject.onNext(webView.scrollView.contentOffset.y)
        }
    }
}

extension CourseDetailInfoView: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        contentSizeObser.onNext(webView.scrollView.contentSize)
    }
}
