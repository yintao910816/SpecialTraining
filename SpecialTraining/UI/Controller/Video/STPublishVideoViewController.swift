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
    @IBOutlet weak var classificationOutlet: UILabel!
    
    private var coverImage: UIImage?
    
    private var managerPicker: ImagePickerManager!
    
    @IBAction func actions(_ sender: UIButton) {
        switch sender.tag {
        case 100:
            // 保存
            navigationController?.dismiss(animated: true, completion: nil)
        case 101:
            // 发布
            performSegue(withIdentifier: "publishUserVidesSegue", sender: nil)
//        case 102:
//            // 选择分类
//            break
        case 103:
            // 选择机构
            break
        default:
            break
        }
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func setupUI() {
        meidaChoseOutlet.setImage(coverImage, for: .normal)
        
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
        
        NotificationCenter.default.rx.notification(NotificationName.PublishVideo.ChooseClassifications)
            .subscribe(onNext: { [weak self] no in
                self?.classificationOutlet.text = (no.object as? String)
            })
            .disposed(by: disposeBag)
    }
    
    override func prepare(parameters: [String : Any]?) {
        coverImage = parameters?["image"] as? UIImage
    }
}

extension STPublishVideoViewController: ImagePickerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage?, editedImage: UIImage?) {
        meidaChoseOutlet.setImage(image, for: .normal)
    }
}
