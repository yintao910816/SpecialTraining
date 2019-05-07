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
    
    private var videoSTSModel: VideoSTSModel?
    
    override init() {
        super.init()
        client = VODUploadSVideoClient()
        client.delegate = self
        
        publishDataSubject
            ._doNext(forNotice: hud)
            .do(onNext: { [unowned self] info in self.mediaData = info })
            .flatMap{ [unowned self] _ in self.getSTSInfo() }
            .subscribe(onNext: { [unowned self] stsData in
                self.videoSTSModel = stsData
                self.uploadVideo(stsModel: stsData)
                }, onError: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func getUploadAuthRefreshData() ->Observable<VideoUploadAuthRefreshModel>{
        return STProvider.request(.aliyunUpLoadAuth(title: mediaData!.0, filename: "1.mp4", cate_id: "1", member_id: "\(userDefault.uid)"))
            .map(model: VideoUploadAuthRefreshModel.self)
            .asObservable()
    }
    
    private func getSTSInfo() ->Observable<VideoSTSModel> {
        return STProvider.request(.sts())
            .map(model: VideoSTSModel.self)
            .asObservable()
    }
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
        info.templateGroupId = "5ca91602d1f35b7598999244d090ead1"
        info.title = title
        info.desc = ""
        info.cateId = NSNumber.init(value: 1)
        info.tags = "video"
        
        client.upload(withVideoPath: videoPath,
                      imagePath: coverPath,
                      svideoInfo: info,
                      accessKeyId: stsModel.Credentials.AccessKeyId,
                      accessKeySecret: stsModel.Credentials.AccessKeySecret,
                      accessToken: stsModel.Credentials.SecurityToken)
    }
    
    func uploadSuccess(with result: VodSVideoUploadResult!) {
        PrintLog("上传成功：imageUrl -- \(String(describing: result.imageUrl)) videoId -- \(String(describing: result.videoId))")
        STProvider.request(.insert_video_info(vodSVideoModel: result, cateID: "1", title: mediaData?.0 ?? ""))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] res in
                if res.errno == 0 {
                    self?.hud.noticeHidden()
                    self?.popSubject.onNext(Void())
                }else {
                    self?.hud.failureHidden(res.errmsg)
                }
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
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
                self?.hud.failureHidden(self?.errorMessage(error))
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
