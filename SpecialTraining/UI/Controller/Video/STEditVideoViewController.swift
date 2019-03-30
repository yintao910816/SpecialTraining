//
//  STEditVideoViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/2/21.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STEditVideoViewController: TJPlayerViewController {

    private var finishiButton: UIButton!
    private var closeButton: UIButton!
    private var bottomBar: UIView!
    private var remindLable: UILabel!
    private var actionButton: UIButton!
    
    private lazy var hud: NoticesCenter = { return NoticesCenter() }()

    public var videoDuration: Int = 0
    
    public var representChooseVideoCallback: (()->())?
    
    deinit {
        PrintLog("释放了：\(self)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cutDoneBlock = { [weak self] (assetm, path) in
            self?.getFirstImage(path: path, callBack: { image in
                self?.hud.noticeHidden()
                let publishVideoCtrl = UIStoryboard.init(name: "STVideo", bundle: Bundle.main).instantiateViewController(withIdentifier: "PublishVideoCtrl")
                publishVideoCtrl.prepare(parameters: ["image": image as Any, "videoURL": path as Any])
                self?.navigationController?.pushViewController(publishVideoCtrl, animated: true)
            })
        }
        
        finishiButton = UIButton.init()
        finishiButton.backgroundColor = ST_MAIN_COLOR
        finishiButton.setTitle("完成", for: .normal)
        finishiButton.layer.cornerRadius = 3
        finishiButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        finishiButton.setTitleColor(.white, for: .normal)
        finishiButton.addTarget(self, action: #selector(finishAction), for: .touchUpInside)

        closeButton = UIButton.init()
        closeButton.setImage(UIImage.init(named: "videoClose"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        
        bottomBar = UIView()
        bottomBar.backgroundColor = RGB(140, 147, 141)
        
        remindLable = UILabel()
        remindLable.textColor = .white
        remindLable.font = UIFont.systemFont(ofSize: 14)
        
        actionButton = UIButton()
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        actionButton.backgroundColor = ST_MAIN_COLOR
        actionButton.layer.cornerRadius = 3
        actionButton.addTarget(self, action: #selector(bottomAction), for: .touchUpInside)

        view.addSubview(finishiButton)
        view.addSubview(closeButton)
        view.addSubview(bottomBar)
        bottomBar.addSubview(remindLable)
        bottomBar.addSubview(actionButton)
        
        finishiButton.snp.makeConstraints{
            $0.right.equalTo(view).offset(-10)
            $0.top.equalTo(view).offset(LayoutSize.fitTopArea + 30)
            $0.size.equalTo(CGSize.init(width: 50, height: 22))
        }
        
        closeButton.snp.makeConstraints{
            $0.left.equalTo(view).offset(10)
            $0.centerY.equalTo(finishiButton.snp.centerY)
            $0.size.equalTo(CGSize.init(width: 40, height: 40))
        }

        bottomBar.snp.makeConstraints{
            $0.left.equalTo(view)
            $0.right.equalTo(view)
            $0.bottom.equalTo(view)
            $0.height.equalTo(100)
        }

        remindLable.snp.makeConstraints{
            $0.left.equalTo(bottomBar).offset(10)
            $0.centerY.equalTo(bottomBar.snp.centerY)
        }

        actionButton.snp.makeConstraints{
            $0.right.equalTo(bottomBar).offset(-10)
            $0.centerY.equalTo(bottomBar.snp.centerY)
            $0.height.equalTo(27)
            $0.width.equalTo(30)
        }
        
        dealView()
    }
    
    @objc private func finishAction() {
        hud.noticeLoading()
        removeNotification()
        cutVideoAction()
    }
    
    @objc private func closeAction() {
        removeNotification()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func bottomAction() {
        if videoDuration > 15 {
            prepareCut()
        }else if videoDuration < 5 {
            removeNotification()
            navigationController?.popViewController(animated: true)
            representChooseVideoCallback?()
        }
    }
    
    private func dealView() {
        if videoDuration < 5 {
            less5()
        }else if videoDuration > 15 {
            moreThen15()
        }else {
            prepareCut()
        }
    }
    
    private func less5() {
        showChooseView(false)
        bottomBar.isHidden = false
        finishiButton.isHidden = true
        remindLable.text = "您的视频不足5秒请重新选择"
        actionButton.setTitle("重新选择", for: .normal)
        actionButton.snp.updateConstraints{ $0.width.equalTo(80) }
    }
    
    private func moreThen15() {
        showChooseView(false)
        bottomBar.isHidden = false
        finishiButton.isHidden = true
        remindLable.text = "您的视频超过5秒请重新编辑"
        actionButton.setTitle("编辑", for: .normal)
        actionButton.snp.updateConstraints{ $0.width.equalTo(50) }
    }
    
    private func prepareCut() {
        showChooseView(true)
        bottomBar.isHidden = true
        finishiButton.isHidden = false
    }
}

extension STEditVideoViewController {

    private func getFirstImage(path: String?, callBack: @escaping ((UIImage?) ->())) {
        if let urlStr = path {
            let url = URL.init(fileURLWithPath: urlStr)
            splitVideoFileUrlFps(splitFileUrl: url, fps: 2) { (ret, images) in
                DispatchQueue.main.async {
                    if images.count > 0 { callBack(images.first) }
                }
            }
        }else {
            callBack(nil)
        }
    }
}
