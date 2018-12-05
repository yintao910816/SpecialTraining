//
//  STPublishVideoViewController.swift
//  SpecialTraining
//
//  Created by sw on 05/12/2018.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class STPublishVideoViewController: BaseViewController {

    @IBOutlet weak var inputTextOutlet: PlaceholderTextView!
    @IBOutlet weak var meidaChoseOutlet: UIButton!
    @IBOutlet weak var saveOutlet: UIButton!
    
    private var managerPicker: ImagePickerManager!
    
    @IBAction func actions(_ sender: UIButton) {
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func setupUI() {
        inputTextOutlet.placeholder = "写标题并使用合适的话题，能让更多人看到"
        inputTextOutlet.font = UIFont.systemFont(ofSize: 14)
        
        managerPicker = ImagePickerManager.init(viewController: self)
        managerPicker.pickerDelegate = self
    }
    
    override func rxBind() {
        
        meidaChoseOutlet.rx.tap.asDriver()
            .drive(onNext: { _ in
                NoticesCenter.alertActionSheet(actionTitles: ["相册", "相机"], cancleTitle: "取消", presentCtrl: self, callBackCancle:  nil, callBackChoose: { idx in
                    self.managerPicker.openPickerSignal.onNext((MediaType(rawValue: idx)!, true))
                })
            })
            .disposed(by: disposeBag)
    }
}

extension STPublishVideoViewController: ImagePickerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage?, editedImage: UIImage?) {
        meidaChoseOutlet.setImage(image, for: .normal)
    }
}
