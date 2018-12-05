//
//  ImagePickerManager.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/24.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import Photos
import RxSwift

class ImagePickerManager: NSObject {

    weak var pickerDelegate: ImagePickerDelegate?

    private var presentViewController: UIViewController!
    private var pickImageController: UIImagePickerController!

    private let disposeBag = DisposeBag()

    public let openPickerSignal = PublishSubject<(MediaType, Bool)>()

    deinit {
        PrintLog("释放了 \(self)")
    }

    init(viewController: UIViewController) {
        super.init()
        presentViewController = viewController

        pickImageController = UIImagePickerController.init()
        pickImageController.delegate = self

        openPickerSignal.subscribe(onNext: { [unowned self] data in
            switch data.0 {
            case .photoLibrary:
                self.openPhotoLibrary(allowsEditing: data.1)
            case .camera:
                self.openCamera(allowsEditing: data.1)
            case .savedPhotosAlbum:
                break
            }
        })
        .disposed(by: disposeBag)
    }

    private func openPhotoLibrary(allowsEditing: Bool) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            //获取相册权限
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ [weak self] _ in self?.openPhotoLibrary(allowsEditing: allowsEditing) })
            case .restricted:
                //此应用程序没有被授权访问的照片数据
                NoticesCenter.alert(message: "请前往设置中心授权相册权限")
            case .denied:
                //用户已经明确否认了这一照片数据的应用程序访问
                NoticesCenter.alert(message: "请前往设置中心授权相册权限")
            case .authorized:
                //已经有权限
                pickImageController.allowsEditing = allowsEditing
                pickImageController.sourceType = .photoLibrary;
                presentViewController.present(pickImageController, animated: true, completion: nil)
            }
        }else {
            NoticesCenter.alert(message: "此设备不支持相册")
        }
    }

    private func openCamera(allowsEditing: Bool) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //获取相机权限
            let status = AVCaptureDevice.authorizationStatus(for: .metadata)
            switch status {
            case .notDetermined:
                // 第一次触发
                AVCaptureDevice.requestAccess(for: .metadata) { [weak self] _ in self?.openCamera(allowsEditing: allowsEditing) }
            case .restricted:
                //此应用程序没有被授权访问的照片数据
                NoticesCenter.alert(message: "此应用程序没有被授权访问的照片数据")
            case .denied:
                //用户已经明确否认了这一照片数据的应用程序访问
                NoticesCenter.alert(message: "请前往设置中心授权相册权限")
                break
            case .authorized://已经有权限
                //跳转到相机或者相册
                pickImageController.allowsEditing = allowsEditing
                pickImageController.sourceType = .camera
                //弹出相册页面或相机
                presentViewController.present(pickImageController, animated: true, completion: nil)
            }
        }else {
            NoticesCenter.alert(message: "此设备不支持摄像")
        }
    }

}

extension ImagePickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

//        if  info[UIImagePickerController.InfoKey.mediaType] as? AVMediaType  {
//
//        }
        pickerDelegate?.imagePickerController(picker, didFinishPickingImage: info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
                                              editedImage: info[UIImagePickerController.InfoKey.editedImage] as? UIImage)
        
        picker.dismiss(animated: true, completion: nil)
    }
}

protocol ImagePickerDelegate: class {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage?, editedImage: UIImage?)
    
}

public enum MediaType: Int {
   
    case photoLibrary = 0
    
    case camera
    
    case savedPhotosAlbum
}
