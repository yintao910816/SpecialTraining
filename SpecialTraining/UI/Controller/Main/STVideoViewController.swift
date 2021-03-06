//
//  STVideoViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import MobileCoreServices

class STVideoViewController: BaseViewController, VMNavigation {

    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var contentCollectionView: UICollectionView!
    @IBOutlet weak var publishOutlet: UIButton!
    
    @IBOutlet weak var topViewHeightCns: NSLayoutConstraint!
    @IBOutlet weak var topViewTopCns: NSLayoutConstraint!
    
    private var floatView: TYFloatView!
    
    var viewModel: VideoViewModel!
    
    @IBAction func actions(_ sender: UIButton) {
        floatView.viewAnimotion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func photoAlbumPermissions() {
        let authStatus = PHPhotoLibrary.authorizationStatus()        
        if authStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                if status == .authorized {

                }
            }
        } else if authStatus == .authorized  {

        } else {
            
        }
    }
    
    override func setupUI() {
        if #available(iOS 11, *) {
            contentCollectionView.contentInsetAdjustmentBehavior = .never
            menuCollectionView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }

        topViewHeightCns.constant += (LayoutSize.topVirtualArea + 20)
        
        let layout = VideoFlowLayout.init()
        layout.interSpacing = 7
        layout.lineSpacing  = 7
        layout.edgeInsets   = .init(top: 7, left: 7, bottom: 7, right: 7)
        layout.delegate = self
        
        contentCollectionView.collectionViewLayout = layout
        
        contentCollectionView.register(UINib.init(nibName: "VideoCell", bundle: Bundle.main), forCellWithReuseIdentifier: "VideoCellID")
        menuCollectionView.register(UINib.init(nibName: "VideoClassificationCell", bundle: Bundle.main), forCellWithReuseIdentifier: "VideoClassificationCellID")
        
        floatView = TYFloatView.creatView(belowViewFrame: publishOutlet.frame,
                                          convertView: view,
                                          superView: view,
                                          menuDatasource: ["拍摄", "上传", "我的乐秀"],
                                          fontSize: 14)
        
        floatView.didSelectedCallBack = { [unowned self] title in
            if STHelper.userIsLogin() {
                if title == "拍摄" {
                    self.performSegue(withIdentifier: "publishVideoSegue", sender: nil)
                }else if title == "上传" {
                    self.showVideoVC()
                }else if title == "我的乐秀" {
                    STVideoViewController.sbPush("STVideo", "myVideosCtrl")
                }
            }
        }
    }
    
    override func rxBind() {
        viewModel = VideoViewModel()
        
        viewModel.videoListSource
            .asObservable()
            .bind(to: contentCollectionView.rx.items(cellIdentifier: "VideoCellID", cellType: VideoCell.self)) { (row, model, cell) in
                cell.model = model
            }
            .disposed(by: disposeBag)

        viewModel.videoClassifationSource
            .asObservable()
            .bind(to: menuCollectionView.rx.items(cellIdentifier: "VideoClassificationCellID", cellType: VideoClassificationCell.self)) { (row, element, cell) in
                cell.model = element
            }
            .disposed(by: disposeBag)
        
        menuCollectionView.rx.modelSelected(VideoCateListModel.self)
            .asDriver()
            .drive(viewModel.classifationChangeObser)
            .disposed(by: disposeBag)
        
        contentCollectionView.rx.modelSelected(VideoListModel.self)
            .asDriver()
            .drive(onNext: { [unowned self] model in
                self.performSegue(withIdentifier: "demandVideoSegue", sender: model)
            })
            .disposed(by: disposeBag)

        viewModel.reloadSubject.onNext(Void())
    }
    
    private func videoPlay(videoDuration: Int, videoUrl: URL) {
        let pvc = STEditVideoViewController.init()
        pvc.videoUrl = videoUrl
        pvc.videoDuration = videoDuration
        pvc.representChooseVideoCallback = { [weak self] in
            self?.showVideoVC()
        }
        navigationController?.pushViewController(pvc, animated: true)
    }
    
    private func showVideoVC() {
        PhotoAlbums.photoVideo(withMaxDurtion: 60, delegate: self, updateUIFinishPicking: { image in
            
        }, didFinishPickingVideoHandle: { [unowned self] (url, image, obj) in
            if let _url = url {
                // 播放视频
                self.videoPlay(videoDuration: STHelper.getVideoDuration(path: _url), videoUrl: _url)
            }else {
                NoticesCenter.alert(title: "提示", message: "视频无效，请重新选择")
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let videoDemandVC = segue.destination as? STVideoDemandViewController {
            videoDemandVC.videoInfoModel = (sender as! VideoListModel)
        }
    }
}

extension STVideoViewController: FlowLayoutDelegate {
    
    func itemContent(layout: BaseFlowLayout, indexPath: IndexPath) -> CGSize {
        let model = viewModel.videoListSource.value[indexPath.row]
        return model.size
    }
}
