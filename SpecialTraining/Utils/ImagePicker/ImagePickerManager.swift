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
        
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
//
//        [library assetForURL:url resultBlock:^(ALAsset *asset){
//
//
//        //获取图片
//        UIImage *image = info[UIImagePickerControllerOriginalImage];
//        //获取照片名称
//        NSString *fileName = asset.defaultRepresentation.filename;
//        //获取照片元数据  ,包含一些RGB什么的
//        NSString *fileName = asset.defaultRepresentation.metadata;
//
//        //获取照片大小比例等等... defaultRepresentation的属性中可以查看
//        ....
//
//        //开始上传 (此方法无视 , 这是项目中需要的方法)
//        [JYCenterAddUploadManager executeUpLoadFileWithFile:image fileParent:@"root" fileName:fileName fileType:JYUpLoadFileTypeImage response:^(JYDownLoadTaskModel *taskModel) {
//
//        }];
//
//        }failureBlock:^(NSError *error){
//
//        [NSObject alertShowWithSingleTipWithtarget:self title:@"获取相册失败" makeSureClick:nil];
//
//        }];
        

//        let library = ALAssetsLibrary.init()
//        PrintLog(info[UIImagePickerController.InfoKey.mediaURL])
//        PrintLog((info[UIImagePickerController.InfoKey.mediaURL] as! URL).absoluteString)
//
//        library.asset(for: info[UIImagePickerController.InfoKey.mediaURL] as! URL, resultBlock: { asset in
//
//        }) { error in
//            
//        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

protocol ImagePickerDelegate: class {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage)
    
}
