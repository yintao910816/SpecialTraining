//
//  STUpdateFileViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/12/6.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STUpdateFileViewController: BaseViewController {
    
    private var imagePicker: ImagePickerManager!
    
    private var choseTag: Int!
    
    @IBAction func actions(_ sender: UIButton) {
        
        NoticesCenter.alertActionSheet(title: nil,
                                       actionTitles: ["相册", "拍照"],
                                       cancleTitle: "取消",
                                       presentCtrl: self,
                                       callBackCancle: nil) { [unowned self] idx in
                                       
                                        self.choseTag = sender.tag
                                        if idx == 0 {
                                            self.imagePicker.openPickerSignal.onNext((.photoLibrary, false))
                                        }else if idx == 1 {
                                            self.imagePicker.openPickerSignal.onNext((.camera, false))
                                        }
                                        
        }
    }
    
    override func setupUI() {
        imagePicker = ImagePickerManager.init(viewController: self)
        imagePicker.pickerDelegate = self
        
        for idx in 100...103 {
            (view.viewWithTag(idx) as! UIButton).imageView?.contentMode = .scaleAspectFill
        }
    }
    
    override func rxBind() {
        
    }
}

extension STUpdateFileViewController: ImagePickerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage?, editedImage: UIImage?) {
        (view.viewWithTag(choseTag) as! UIButton).setImage(image, for: .normal)
    }
}
