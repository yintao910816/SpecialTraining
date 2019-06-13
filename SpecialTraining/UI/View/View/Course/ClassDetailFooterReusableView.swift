

//
//  ClassDetailFooterReusableView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/6/12.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxSwift

class ClassDetailFooterReusableView: UICollectionReusableView {
    
    @IBOutlet var contentView: UICollectionReusableView!
    @IBOutlet weak var webView: UIWebView!
    
    private let disposeBag = DisposeBag()
    
    public let contentSizeObser = PublishSubject<CGSize>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = (Bundle.main.loadNibNamed("ClassDetailFooterReusableView", owner: self, options: nil)?.first as! UICollectionReusableView)
        addSubview(contentView)
        
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.isDirectionalLockEnabled = true
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
        
//        webView.scrollView.rx.observeWeakly(CGSize.self, "contentSize")
//            .bind(to: contentSizeObser)
//            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    var classId: String! {
        didSet {
            if let requestUrl = APIAssistance.classDetailH5URL(classId: classId) {
                let request = URLRequest.init(url: requestUrl)
                webView.loadRequest(request)
            }
        }
    }
}

extension ClassDetailFooterReusableView: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        contentSizeObser.onNext(webView.scrollView.contentSize)
        webView.delegate = nil
    }
}
