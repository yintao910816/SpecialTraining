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
        
//        publishDataSubject
//            ._doNext(forNotice: hud)
//            .do(onNext: { [unowned self] info in self.mediaData = info })
//            .flatMap{ [unowned self] _ in self.getSTSInfo() }
//            .subscribe(onNext: { [unowned self] stsData in
//                self.uploadVideo(stsModel: stsData)
//                }, onError: { error in
//                print(error.localizedDescription)
//            })
//            .disposed(by: disposeBag)
    }
    
    private func getUploadAuthRefreshData() ->Observable<VideoUploadAuthRefreshModel>{
        return STProvider.request(.aliyunUpLoadAuth(title: mediaData!.0, filename: "1.mp4", cate_id: "1", member_id: "1"))
            .map(model: VideoUploadAuthRefreshModel.self)
            .asObservable()
    }
    
//    private func getSTSInfo() ->Observable<VideoSTSModel> {
//        return STHttpsProvider.request(.sts())
//            .map(model: VideoSTSModel.self)
//            .asObservable()
//    }
}

extension PublishVideoViewModel: VODUploadSVideoClientDelegate {
    
    private func uploadVideo(stsModel: VideoSTSModel) {
        hud.noticeLoading()
        
        guard let title = mediaData?.0, title.count > 0 else {
                hud.failureHidden("请填写视频标题")
                return
        }

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
        info.title = title
        info.desc = ""
        info.cateId = NSNumber.init(value: 1)
        info.tags = "video"
        
//        let AccessKeySecret = "3JHkYFmiFCL9k7EgreB5JXrupEnb3Fpy15Yn1Qj5Cz2A"
//        let AccessKeyId = "STS.NKQiLBoZ5iUKHZ9umn6N26kfe"
//        let SecurityToken = "CAIS6wF1q6Ft5B2yfSjIr4jkIvb2goUU3pegSnyIkW07OsEe2a7Nhzz2IH1Me3hqCe0btv0/mGtS6/4TlqxtSpNIQhQtgWXrINEFnzm6aq/t5uaXj9Vd+rDHdEGXDxnkprywB8zyUNLafNq0dlnAjVUd6LDmdDKkLTfHWN/z/vwBVNkMWRSiZjdrHcpfIhAYyPUXLnzML/2gQHWI6yjydBM25VYk1DkjtfzhmZzBsErk4QekmrNPlePYOYO5asRgBpB7Xuqu0fZ+Hqi7i3MItEkQpPor1PUUpWyd44nMGTZP5BmcNO7Z4h2X+c+63zxQGoABV2PacdkYV5cPToiQSH2FPnNUpXFGwRbOx8OtGyoWJ2nAkn0+uOA7fuZYybaJRu8rvYOhI5SSAPcbGs9IgNjq+KNLKh9nxpFLcnotDwNixRwDiKMHOxy5ypuvfTRobJyfLeAYIhKXn0DYT1mFNyJi0uMGea+rZZJJFiYd1O/clQY="
        
        client.upload(withVideoPath: videoPath,
                      imagePath: coverPath,
                      svideoInfo: info,
                      accessKeyId: stsModel.Credentials.AccessKeyId,
                      accessKeySecret: stsModel.Credentials.AccessKeySecret,
                      accessToken: stsModel.Credentials.SecurityToken)
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
//        client.refresh(withAccessKeyId: <#T##String!#>, accessKeySecret: <#T##String!#>, accessToken: <#T##String!#>, expireTime: <#T##String!#>)
    }
    
    func uploadRetry() {
        PrintLog("上传开始重试")
    }
    
    func uploadRetryResume() {
        PrintLog("上传结束重试，继续上传")
    }

}
