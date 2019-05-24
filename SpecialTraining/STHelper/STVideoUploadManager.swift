//
//  STVideoUploadManager.swift
//  SpecialTraining
//
//  Created by sw on 07/05/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class STVideoUploadManager: NSObject {

    public let startUploadSubject = PublishSubject<UploadVideoInfo>()
    public let uploadSuccessSubject = PublishSubject<Void>()
    
    private var client: VODUploadSVideoClient!
    private let hud = NoticesCenter()
    
    private let disposeBag = DisposeBag()
    
    private var uploadInfo = UploadVideoInfo()
    private var videoSTSModel: VideoSTSModel?
    
    deinit {
        PrintLog("释放了：\(self)")
    }
    
    override init() {
        super.init()
        
        client = VODUploadSVideoClient()
        client.maxRetryCount = 2
        client.timeoutIntervalForRequest = 15.0 * 1000.0
        client.transcode = false
        client.region = "cn-shanghai"
        client.uploadPartSize = 1024 * 1024
        
        client.delegate = self
        
        startUploadSubject
            .do(onNext: { [unowned self] in self.uploadInfo = $0 })
            ._doNext(forNotice: hud)
            .flatMap { [unowned self] _ in self.getSTSInfo() }
            .subscribe(onNext: { [weak self] stsModel in
                self?.uploadVideo(stsModel: stsModel)
            }, onError: { [weak self] error in
                self?.hud.failureHidden(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }

    private func uploadVideo(stsModel: VideoSTSModel) {
        videoSTSModel = stsModel
        
        guard uploadInfo.title.count > 0 else {
            hud.failureHidden("请填写视频标题")
            return
        }
        
        guard let imageCover = uploadInfo.cover,
            let imageData = imageCover.jpegData(compressionQuality: 0.6) else {
                hud.failureHidden("请选择封面")
                return
        }
        
        guard uploadInfo.videoPath.count > 0 else {
            hud.failureHidden("请选择视频")
            return
        }
        
        uploadInfo.fileName = Date().milliStamp
        let coverPath = FileService.share.writeToTempFile(data: imageData, fileName: uploadInfo.fileName)
        
        let info = VodSVideoInfo()
//        info.templateGroupId = "5ca91602d1f35b7598999244d090ead1"
        info.title = uploadInfo.title
        info.desc = ""
        info.cateId = NSNumber.init(value: 1)
        info.tags = "video"
        
        client.upload(withVideoPath: uploadInfo.videoPath,
                      imagePath: coverPath,
                      svideoInfo: info,
                      accessKeyId: stsModel.Credentials.AccessKeyId,
                      accessKeySecret: stsModel.Credentials.AccessKeySecret,
                      accessToken: stsModel.Credentials.SecurityToken)
    }

    private func getUploadAuthRefreshData() ->Observable<VideoUploadAuthRefreshModel>{
        return STProvider.request(.aliyunUpLoadAuth(title: uploadInfo.title,
                                                    filename: uploadInfo.fileName,
                                                    cate_id: uploadInfo.cateId,
                                                    member_id: "\(userDefault.uid)"))
            .map(model: VideoUploadAuthRefreshModel.self)
            .asObservable()
    }
    
    private func getSTSInfo() ->Observable<VideoSTSModel> {
        return STProvider.request(.sts)
            .map(model: VideoSTSModel.self)
            .asObservable()
    }
}

extension STVideoUploadManager: VODUploadSVideoClientDelegate {
    
    func uploadSuccess(with result: VodSVideoUploadResult!) {
        PrintLog("上传成功：imageUrl -- \(String(describing: result.imageUrl)) videoId -- \(String(describing: result.videoId))")
        FileService.share.removeTempFile(fileName: uploadInfo.fileName)
        STProvider.request(.insert_video_info(vodSVideoModel: result, cateID: uploadInfo.cateId, title: uploadInfo.title))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] res in
                if res.errno == 0 {
                    self?.hud.noticeHidden()
                    self?.uploadSuccessSubject.onNext(Void())
                }else {
                    self?.hud.failureHidden(res.errmsg)
                }
            }) { [weak self] error in
                self?.hud.failureHidden(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func uploadFailed(withCode code: String!, message: String!) {
        PrintLog("上传失败：message -- \(String(describing: message)) code --\(String(describing: code))")
    }
    
    func uploadProgress(withUploadedSize uploadedSize: Int64, totalSize: Int64) {
        PrintLog("上传进度：uploadedSize -- \(uploadedSize) -- \(totalSize)")
    }
    
    func uploadTokenExpired() {
        PrintLog("上传token过期")
        getUploadAuthRefreshData()
            .subscribe(onNext: { [weak self] data in
                guard let strongSelf = self else { return }
                guard let v = strongSelf.videoSTSModel else {
                    strongSelf.hud.failureHidden("认证失败")
                    return
                }
                strongSelf.client.refresh(withAccessKeyId: v.Credentials.AccessKeyId,
                                          accessKeySecret: v.Credentials.AccessKeySecret,
                                          accessToken: data.UploadAuth,
                                          expireTime: "")
                }, onError: { [weak self] error in
                    self?.hud.failureHidden(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func uploadRetry() {
        PrintLog("上传开始重试")
    }
    
    func uploadRetryResume() {
        PrintLog("上传结束重试，继续上传")
    }

}

class UploadVideoInfo {
    var cover: UIImage?
    var videoPath: String = ""
    var title: String = ""
    var fileName: String = ""
    var cateId: String = "1"
}
