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
    
    /// 标题-封面-视屏地址
    let publishDataSubject = PublishSubject<(String, UIImage?, String)>()
        
    private var uploadVideoInfo = UploadVideoInfo()
    private var videoSTSModel: VideoSTSModel?
    
    private let uploadManager = STVideoUploadManager()
    
    override init() {
        super.init()
        
        publishDataSubject
            .map({ [unowned self] info -> UploadVideoInfo in
                self.uploadVideoInfo.cover = info.1
                self.uploadVideoInfo.videoPath = info.2
                self.uploadVideoInfo.title = info.0
                return self.uploadVideoInfo
            })
            .bind(to: uploadManager.startUploadSubject)
            .disposed(by: disposeBag)
        
        uploadManager.uploadSuccessSubject
            .bind(to: popSubject)
            .disposed(by: disposeBag)
    }
    
}
