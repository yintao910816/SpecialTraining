//
//  APIServer.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/7/24.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import Moya
import Result

struct MoyaPlugins {
    
    static let MyNetworkActivityPlugin = NetworkActivityPlugin { (change, _) -> () in
        switch(change){
        case .ended:
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        case .began:
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
//    static let requestTimeoutClosure = {(endpoint: Endpoint<API>, done: @escaping MoyaProvider<API>.RequestResultClosure) in
//        guard var request = endpoint.urlRequest else { return }
//
//        request.timeoutInterval = 30    //设置请求超时时间
//        done(.success(request))
//    }
    
}

public final class RequestLoadingPlugin: PluginType {

    public func willSend(_ request: RequestType, target: TargetType) {
        let api = target as! API    
        #if DEBUG
            switch api.task {
            case .requestParameters(let parameters, _):
                let apath = api.baseURL.absoluteString + api.path + ((parameters as NSDictionary?)?.keyValues() ?? "")
                print("发送请求地址：\(apath)")
            default:
                print(api.baseURL.absoluteString + api.path)
            }
        #endif

    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        
        switch result {
        case .success(let response):
            guard let api = target as? API else {
                return
            }
//            switch api {
//            case .wchatLogin(_):
//                do {
//                    let json = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
//
//                    guard let rdic = json as? [String : Any] else {
//                        return
//                    }
//
//                    if let token = rdic["Token"] as? String {
//                        userDefault.token = token
//                    }
//                } catch  {
//                    PrintLog(error)
//                }
//            case .addComicCase(_, _), .delComicCase(_):
//                NotificationCenter.default.post(name: NotificationName.Reader.BookSelfCaseReload, object: nil)
//            default:
//                break
//            }
            
            break
        case .failure(let error):
            PrintLog(error)
            break
        }
    }

}
