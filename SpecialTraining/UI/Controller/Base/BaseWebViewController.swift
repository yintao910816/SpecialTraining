//
//  BaseWebViewController.swift
//  HuChuangApp
//
//  Created by sw on 13/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import JavaScriptCore

class BaseWebViewController: BaseViewController {

    var url: String = ""

    private var context : JSContext?
    private var webTitle: String?
    
    private lazy var hud: NoticesCenter = {
        return NoticesCenter()
    }()
    
    private lazy var webView: UIWebView = {
        let w = UIWebView()
        w.backgroundColor = .clear
        w.scrollView.bounces = false
        w.delegate = self
        return w
    }()
    
    override func prepare(parameters: [String : Any]?) {
        guard let _url = parameters?["url"] as? String else {
            return
        }
        
        webTitle = (parameters?["title"] as? String)
        url = _url
    }
    
    func webCanBack(_ goBack: Bool = true) -> Bool {
        if webView.canGoBack == true,
            goBack == true {
            webView.goBack()
            return true
        }
        return false
    }
    
    override func setupUI() {
        view.backgroundColor = .white
        if #available(iOS 11, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }

        view.addSubview(webView)
        
        if webTitle?.count ?? 0 > 0 { navigationItem.title = webTitle }
        
        webView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
        
        requestData()
    }

    private func requestData(){
        hud.noticeLoading()
        
        if let requestUrl = URL.init(string: url) {
            let request = URLRequest.init(url: requestUrl)
            webView.loadRequest(request)
        }else {
            hud.failureHidden("url错误")
        }
    }

    private func setTitle() {
        if let title = webView.stringByEvaluatingJavaScript(from: "document.title"){
            navigationItem.title = title
        }
    }

}

extension BaseWebViewController: UIWebViewDelegate{
   
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool{
        
        let s = request.url?.absoluteString
        PrintLog("shouldStartLoadWith -- \(String(describing: s))")

        if s == "app://reload"{
            webView.loadRequest(URLRequest.init(url: URL.init(string: url)!))
            return false
        }
        
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView){
        PrintLog("didStartLoad")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        PrintLog("didFinishLoad")
        hud.noticeHidden()
        
        context = (webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext)
        
        // 设置标题
        let changeTitle: @convention(block) () ->() = {[weak self] in
            guard let params = JSContext.currentArguments() else { return }
            
            for idx in 0..<params.count {
                if idx == 0 {
                    let _title = ((params[0] as AnyObject).toString()) ?? ""
                    self?.navigationItem.title = _title
                }
            }
        }
        context?.setObject(unsafeBitCast(changeTitle, to: AnyObject.self), forKeyedSubscript: "changeTitle" as NSCopying & NSObjectProtocol)
        
        let backHomeFnApi: @convention(block) () ->() = {[weak self]in
            DispatchQueue.main.async {
                PrintLog("h5 调用 - backHomeFnApi")
                
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
        context?.setObject(unsafeBitCast(backHomeFnApi, to: AnyObject.self), forKeyedSubscript: "backHomeFnApi" as NSCopying & NSObjectProtocol)
        
        let backToList: @convention(block) () ->() = { [weak self] in
            DispatchQueue.main.async {
                PrintLog("h5 调用 - backToList")
                
                if self?.webView.canGoBack == true {
                    self?.webView.goBack()
                }
            }
        }
        context?.setObject(unsafeBitCast(backToList, to: AnyObject.self), forKeyedSubscript: "backToList" as NSCopying & NSObjectProtocol)
                
        let isApp: @convention(block) () ->() = { [weak self] in
            PrintLog("暂时不用 - isApp")
        }
        context?.setObject(unsafeBitCast(isApp, to: AnyObject.self), forKeyedSubscript: "isApp" as NSCopying & NSObjectProtocol)
        
        let nativeOpenURL: @convention(block) () ->() = { [weak self] in
            PrintLog("暂时不用 - nativeOpenURL")
        }
        context?.setObject(unsafeBitCast(nativeOpenURL, to: AnyObject.self), forKeyedSubscript: "nativeOpenURL" as NSCopying & NSObjectProtocol)
        
        context?.exceptionHandler = {(context, value)in
            PrintLog(value)
        }
        
        setTitle()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        hud.failureHidden(error.localizedDescription)
    }
}

