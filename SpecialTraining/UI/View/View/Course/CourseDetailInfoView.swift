//
//  CourseDetailInfoView.swift
//  SpecialTraining
//
//  Created by sw on 10/06/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxSwift

class CourseDetailInfoView: UIScrollView {
    
    private let disposeBag = DisposeBag()
    private let emptyHeaderHeight: CGFloat = (PPScreenW + 145 + 7 + 29 + 7 + 10)
    
    var webView: UIWebView!
    
    public let animotionHeaderSubject = PublishSubject<CGFloat>()
    /// 可以滚动header的最小contentSize高度
    public var scrollMinContentHeight: CGFloat = 0

    public let contentSizeObser = PublishSubject<CGSize>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let header = UIView.init()
        header.isUserInteractionEnabled = false
        addSubview(header)
        
        webView = UIWebView()
        webView.scrollView.bounces = false
        webView.scrollView.isDirectionalLockEnabled = true
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.delegate = self
        addSubview(webView)
        
        header.snp.makeConstraints{
            $0.top.left.equalTo(0)
            $0.width.equalTo(frame.width)
            $0.height.equalTo(emptyHeaderHeight)
        }
        webView.snp.makeConstraints{
            $0.top.equalTo(header.snp.bottom)
            $0.left.equalTo(0)
            $0.width.equalTo(frame.width)
            $0.height.equalTo(frame.height - emptyHeaderHeight)
        }
        
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

        rx.didScroll.asDriver().map{ [unowned self] in self.contentOffset.y }
            .drive(animotionHeaderSubject)
            .disposed(by: disposeBag)

//        webView.scrollView.rx
//            .observeWeakly(CGSize.self, "contentSize")
//            .bind(to: contentSizeObser)
//            .disposed(by: disposeBag)
        
        contentSize = .init(width: PPScreenW, height: PPScreenH)

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
    var scrollContentOffsetY: CGFloat { return contentOffset.y }
    
    func canAnimotion(offset y: CGFloat) -> Bool {
        return (contentSize.height - height) >= y
    }
    
    func scrollMax(contentOffset y: CGFloat) {
        if (contentSize.height - height) >= y {
            setContentOffset(.init(x: 0, y: y), animated: false)
        }else {
            setContentOffset(.init(x: 0, y: contentOffset.y), animated: true)
            animotionHeaderSubject.onNext(contentOffset.y)
        }
    }
}

extension CourseDetailInfoView: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        contentSizeObser.onNext(webView.scrollView.contentSize)
        print("webView 的内容大小：\(webView.scrollView.contentSize)")
        self.webView.snp.updateConstraints{ $0.height.equalTo(webView.scrollView.contentSize.height) }
        contentSize = .init(width: PPScreenW, height: webView.scrollView.contentSize.height + emptyHeaderHeight)
    }
}
