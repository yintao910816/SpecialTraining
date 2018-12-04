//
//  STUserVideosViewController.swift
//  SpecialTraining
//
//  Created by sw on 03/12/2018.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class STUserVideosViewController: BaseViewController {

    private var viewModel: UserVideosViewModel!
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var bgHeader: UIView!

    @IBOutlet weak var topViewHeightCns: NSLayoutConstraint!
    @IBOutlet weak var topSaveAreaCns: NSLayoutConstraint!
    
    private var collectionView: UserVideosView!
    
    @IBAction func actions(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func setupUI() {
        if UIDevice.current.isX == true {
            topViewHeightCns.constant = 130 + 44
            topSaveAreaCns.constant = 20 + 44
        }else {
            topViewHeightCns.constant = 130
            topSaveAreaCns.constant = 20
        }
        
        let frame = CGRect.init(x: 0, y: 0, width: PPScreenW, height: topViewHeightCns.constant)
        bgHeader.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
        
        collectionView = UserVideosView()
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints{
            $0.left.equalTo(scroll)
            $0.top.equalTo(scroll)
            $0.bottom.equalTo(scroll)
            $0.width.equalTo(PPScreenW)
        }
        
    }
    
    override func rxBind() {
        viewModel = UserVideosViewModel()
        
        viewModel.userVidesDatasource.asDriver()
            .drive(collectionView.datasource)
            .disposed(by: disposeBag)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scroll.contentSize = .init(width: PPScreenW * 2, height: scroll.height)
    }

}
