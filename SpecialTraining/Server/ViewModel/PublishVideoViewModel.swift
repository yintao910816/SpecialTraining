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
    
    private var client: VODUploadSVideoClient!
    
    private var mediaData: (String, UIImage?, String)?
    
    override init() {
        super.init()
        client = VODUploadSVideoClient()
        
        client.delegate = self
        
        publishDataSubject.subscribe(onNext: { [unowned self] data in
            self.mediaData = data
            self.uploadVideo()
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

extension PublishVideoViewModel: VODUploadSVideoClientDelegate {
    
    private func uploadVideo() {
        hud.noticeLoading()
        
        guard let imageCover = mediaData?.1,
            let imageData = imageCover.jpegData(compressionQuality: 0.6) else {
            hud.failureHidden("请选择封面")
            return
        }
        
        guard let videoPath = mediaData?.2 else {
            hud.failureHidden("请选择视频")
            return
        }
        
        let fileName = Date().milliStamp
        let coverPath = FileService.share.writeToTempFile(data: imageData, fileName: fileName)
        
        let info = VodSVideoInfo()
        info.title = mediaData?.2
        info.desc = ""
        info.cateId = NSNumber.init(value: 1)
        info.tags = "video"
        
        let AccessKeySecret = "3YJVJaifpTUyiwvsrBdVDs3ZwpiSzVqe71fHN51Nm8cP"
        let AccessKeyId = "NHCQfwLjFRFLWjS4qeTu5gWjm"
        let SecurityToken = "CAIS6wF1q6Ft5B2yfSjIr4v2GtzDobVn5YSnVUzi0HEwWPoZiJLBjzz2IH1Me3hqCe0btv0/mGtS6/4TlqxtSpNIQhRH2gDoG9EFnzm6aq/t5uaXj9Vd+rDHdEGXDxnkprywB8zyUNLafNq0dlnAjVUd6LDmdDKkLTfHWN/z/vwBVNkMWRSiZjdrHcpfIhAYyPUXLnzML/2gQHWI6yjydBM25VYk1DkjtfzhmZzBsErk4QekmrNPlePYOYO5asRgBpB7Xuqu0fZ+Hqi7i3MItEkQpPor1PUUpWyd44nMGTZP5BmcNO7Z4h2X+c+63zxQGoABl69/I+Y2cD3El8sqyDrP0Gu1c7YdLnJr2Vep8Xuw13fK07cMDVY11Hai/KT2IJsdf+VruqJHkEs26xcKxStGwdwhu1y6AQmYP8C655p32hn3xJbVYeirbk9QlEDN+BDa7IqHE/DP7NRG8rEQNSy2K6PLlC0PNtWEfrMIQkJcigI="

        client.upload(withVideoPath: videoPath,
                      imagePath: coverPath,
                      svideoInfo: info,
                      accessKeyId: AccessKeyId,
                      accessKeySecret: AccessKeySecret,
                      accessToken: SecurityToken)
    }
    
    func uploadSuccess(with result: VodSVideoUploadResult!) {
        PrintLog("上传成功：imageUrl -- \(String(describing: result.imageUrl)) videoId -- \(String(describing: result.videoId))")
    }
    
    func uploadFailed(withCode code: String!, message: String!) {
        PrintLog("上传失败：message -- \(String(describing: message)) code --\(String(describing: code))")
    }
    
    func uploadProgress(withUploadedSize uploadedSize: Int64, totalSize: Int64) {
        PrintLog("上传进度：uploadedSize -- \(uploadedSize) -- \(totalSize)")
    }
    
    func uploadTokenExpired() {
        PrintLog("上传token过期")
    }
    
    func uploadRetry() {
        PrintLog("上传开始重试")
    }
    
    func uploadRetryResume() {
        PrintLog("上传结束重试，继续上传")
    }

}
