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

    public let contentSizeObser = PublishSubject<CGSize>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bounces = false
        
        webView = UIWebView()
        webView.scrollView.bounces = false
        webView.scrollView.isDirectionalLockEnabled = true
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.delegate = self
        addSubview(webView)

        let header = UIView.init()
        header.isUserInteractionEnabled = false
        addSubview(header)
        
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

        rx.didScroll.asDriver().map{ [unowned self] in self.contentOffset.y }
            .drive(animotionHeaderSubject)
            .disposed(by: disposeBag)
        
        contentSize = .init(width: PPScreenW, height: PPScreenH)
        
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
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
        let webHeightString = webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight") ?? "\(height)"
        let webHeight: CGFloat = CGFloat(NumberFormatter().number(from: webHeightString)?.floatValue ?? Float(height))
        
        contentSizeObser.onNext(.init(width: width, height: webHeight))

        self.webView.snp.updateConstraints{ $0.height.equalTo(webHeight) }
        self.webView.scrollView.contentSize = .init(width: width, height: webHeight)
        
        contentSize = .init(width: PPScreenW, height: webHeight + emptyHeaderHeight)
    }
}
