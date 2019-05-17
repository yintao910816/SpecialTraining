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
    @IBOutlet weak var videoCountOutlet: UIButton!
    @IBOutlet weak var userIconOutlet: UIButton!
    @IBOutlet weak var nickNameOutlet: UILabel!
    
    @IBOutlet weak var topViewHeightCns: NSLayoutConstraint!
    @IBOutlet weak var topSaveAreaCns: NSLayoutConstraint!
    
    private var collectionView: UserVideosView!
    
    @IBAction func actions(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func setupUI() {
        if UIDevice.current.isX == true {
            topViewHeightCns.constant = 150 + 44
            topSaveAreaCns.constant = 44
        }

        userIconOutlet.imageView?.contentMode = .scaleAspectFill
        let userData = UserAccountServer.share.loginUser.member
        userIconOutlet.setImage(userData.headimgurl)
        nickNameOutlet.text = userData.nickname
        
        let frame = CGRect.init(x: 0, y: 0, width: PPScreenW, height: topViewHeightCns.constant)
        bgHeader.layer.insertSublayer(STHelper.themeColorLayer(frame: frame), at: 0)
        
        collectionView = UserVideosView()
        scroll.addSubview(collectionView)
        
    }
    
    override func rxBind() {
        viewModel = UserVideosViewModel()
        
        viewModel.videosCountObser.asDriver()
            .drive(videoCountOutlet.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        viewModel.userVidesDatasource.asDriver()
            .drive(collectionView.datasource)
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(MyVidesModel.self)
            .map{ VideoListModel.transform(model: $0) }
            .subscribe(onNext: { [unowned self] data in
                self.performSegue(withIdentifier: "playVideoSegue", sender: data)
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scroll.contentSize = .init(width: scroll.width, height: scroll.height)
        
        collectionView.snp.makeConstraints{
            $0.left.equalTo(scroll.snp.left)
            $0.top.equalTo(scroll.snp.top)
            $0.height.equalTo(scroll.snp.height)
            $0.width.equalTo(scroll.snp.width)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playVideoSegue" {
            let ctrl = segue.destination as! STVideoDemandViewController
            ctrl.videoInfoModel = (sender as! VideoListModel)
        }
    }

}
