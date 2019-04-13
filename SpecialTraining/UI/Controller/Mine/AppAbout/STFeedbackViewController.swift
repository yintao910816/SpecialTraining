//
//  STFeedbackViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/4/14.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STFeedbackViewController: BaseViewController {

    @IBOutlet weak var contentView: UIScrollView!
    
    private var subContentView: FaceBackView!
    
    private var viewModel: FeedbackViewModel!
    
    override func setupUI() {
        subContentView = FaceBackView.init(frame: view.bounds)
        contentView.contentSize = .init(width: view.width, height: subContentView.height)
        contentView.addSubview(subContentView)
    }
    
    override func rxBind() {
        viewModel = FeedbackViewModel.init(input: (fackBackContent: subContentView.faceBackContent,
                                                   phone: subContentView.phone),
                                           submit: subContentView.submitAction)
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
