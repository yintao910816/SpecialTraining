//
//  PublishVideoViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/31.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class PublishVideoViewModel: BaseViewModel {
    
    // 标题-封面-视屏地址
    let publishDataSubject = PublishSubject<(String, UIImage?, String)>()
    
    private var mediaData: (String, UIImage?, String)?
    
    override init() {
        super.init()
        
        publishDataSubject.subscribe(onNext: { [unowned self] data in
            self.mediaData = data
            self.startUpLoad()
        })
        .disposed(by: disposeBag)
    }
    
    private func startUpLoad() {
        getSTSInfo().subscribe(onNext: { model in
            print(model)
        }, onError: { error in
            print(error)
        })
            .disposed(by: disposeBag)
    }
    
    private func getUploadAuthRefreshData() ->Observable<VideoUploadAuthRefreshModel>{
        return STProvider.request(.aliyunUpLoadAuth(title: mediaData!.0, filename: "1.mp4", cate_id: "1", member_id: "1"))
            .map(model: VideoUploadAuthRefreshModel.self)
            .asObservable()
    }
    
    private func getSTSInfo() ->Observable<VideoSTSModel> {
        return STProvider.request(.sts())
            .map(model: VideoSTSModel.self)
            .asObservable()
    }
    
//    private func initAliyunUpliad(uploadAddress: String, ) {
//        
//    }
}
