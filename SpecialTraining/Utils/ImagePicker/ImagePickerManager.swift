//
//  ImagePickerManager.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/24.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import Photos

class ImagePickerManager: NSObject {
    
    weak var delegate: ImagePickerDelegate?
    
    private var presentViewController: UIViewController!
    private var pickImageController: UIImagePickerController!
    
    init(viewController: UIViewController) {
        super.init()
        presentViewController = viewController
        
        pickImageController = UIImagePickerController.init()
        self.pickImageController.delegate=self
    }
    
    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            //获取相册权限
            PHPhotoLibrary.requestAuthorization({ [unowned self] (status) in
                switch status {
                case .notDetermined:
                    NoticesCenter.alert(message: "请前往设置中心授权相册权限")
                    break
                case .restricted://此应用程序没有被授权访问的照片数据
                    break
                case .denied://用户已经明确否认了这一照片数据的应用程序访问
                    NoticesCenter.alert(message: "请前往设置中心授权相册权限")
                    break
                case .authorized://已经有权限
                    //跳转到相机或者相册
                    self.pickImageController.allowsEditing = false
                    self.pickImageController.sourceType = .photoLibrary;
                    //弹出相册页面或相机
                    self.presentViewController.present(self.pickImageController, animated: true, completion: nil)
                    break
                }
            })

        }
    }
}

extension ImagePickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image:UIImage=info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            delegate?.imagePickerController(pickImageController, didFinishPickingImage: image)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

protocol ImagePickerDelegate: class {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage)
    
}
