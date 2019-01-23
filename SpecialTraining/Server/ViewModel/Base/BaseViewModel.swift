//
//  BaseViewModel.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/11/18.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class BaseViewModel: NSObject {

    public let disposeBag = DisposeBag()

    public var isEmptyContentObser = Variable(false)

    lazy var hud: NoticesCenter = {
        return NoticesCenter()
    }()

    // 监听网络请求是否成功 (状态，错误提示信息)
    public var requestSuccess = Variable((true, ""))
    // 重新加载数据
    public var reloadSubject = PublishSubject<Void>()
    // 返回上一个界面
    public let popSubject = PublishSubject<Void>()
    public let pushNextSubject = PublishSubject<Void>()

    public func errorMessage(_ error: Swift.Error) ->String {
        
        if let _error = error as? MapperError {
            return _error.message
        }
        
        guard let _error = error as? MoyaError else {
            return "操作失败"
        }
        
        if let response = _error.response {
            return "错误码：\(response.statusCode)"
        }else {
            return _error.errorDescription ?? "请检查网络是否正常"
        }
        
    }

    deinit {
        PrintLog("释放了 \(self)")
    }
}
