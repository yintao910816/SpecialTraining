//
//  StaticWebView.swift
//  SpecialTraining
//
//  Created by sw on 20/06/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

import RxSwift

class StaticWebView: UIView {
    
    private let disposeBag = DisposeBag()
    
    var webView: UIWebView!
    
    public let contentSizeObser = PublishSubject<CGSize>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        webView = UIWebView()
        webView.scrollView.bounces = false
        webView.scrollView.isDirectionalLockEnabled = true
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.delegate = self
        addSubview(webView)
        
        webView.snp.makeConstraints{
            $0.top.equalTo(0)
            $0.left.equalTo(0)
            $0.width.equalTo(frame.width)
            $0.height.equalTo(frame.height)
        }
        
        if #available(iOS 11.0, *) {
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

extension StaticWebView: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let webHeightString = webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight") ?? "\(height)"
        let webHeight: CGFloat = CGFloat(NumberFormatter().number(from: webHeightString)?.floatValue ?? Float(height))
        
        contentSizeObser.onNext(.init(width: width, height: webHeight))
        
        self.webView.snp.updateConstraints{ $0.height.equalTo(webHeight) }
        
        var rect = frame
        rect.size.height = webHeight
        frame = rect
        
        setNeedsLayout()
        layoutIfNeeded()
        
        print("新高度：\(frame)")
    }
}
