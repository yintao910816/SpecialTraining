//
//  STVideoChoseViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/2/20.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import MobileCoreServices

class STVideoChoseViewController: UIImagePickerController {

    var videoUrl: URL?

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        delegate = self
        modalTransitionStyle = .flipHorizontal
        allowsEditing = true
        sourceType = .savedPhotosAlbum
//        mediaTypes = ["public.movie"]
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

extension STVideoChoseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func videoPlay() {
        let pvc = TJPlayerViewController.init()
        pvc.videoUrl = videoUrl
        navigationController?.pushViewController(pvc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String
        
        if mediaType == String(kUTTypeImage) {
            // 图片
        }else {
            // 视频
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL
            videoUrl = url
            // 播放视频
            videoPlay()
        }
        
    }
    
    
}
