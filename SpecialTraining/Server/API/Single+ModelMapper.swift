//
//  SignalProducer+ModelMapper.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/10/9.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import HandyJSON

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    func mapResponse() -> Single<ResponseModel> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Single<ResponseModel> in
                return Single.just(try response.mapResponse())
            }
            .observeOn(MainScheduler.instance)
    }
    
    func map<T: HandyJSON>(result type: T.Type) -> Single<DataModel<T>> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Single<DataModel<T>> in
                return Single.just(try response.map(result: type))
            }
            .observeOn(MainScheduler.instance)
    }
    
    func map<T: HandyJSON>(resultList type: T.Type) -> Single<DataModel<[T]>> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Single<DataModel<[T]>> in
                return Single.just(try response.map(result: type))
            }
            .observeOn(MainScheduler.instance)
    }
    
    func map<T: HandyJSON>(model type: T.Type) -> Single<T> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Single<T> in
                return Single.just(try response.map(model: type))
            }
            .observeOn(MainScheduler.instance)
    }
    
    func map<T: HandyJSON>(models type: T.Type) -> Single<[T]> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Single<[T]> in
                return Single.just(try response.map(model: type))
            }
            .observeOn(MainScheduler.instance)
    }
}
