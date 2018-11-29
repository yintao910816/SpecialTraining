//
//  IndicaUI.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/5/26.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftGifOrigin

extension UIViewController {
    
    struct RuntimeKey {
        static let loadingView = UnsafeRawPointer.init(bitPattern: "LoadingViewKey".hashValue)
    }
    
    //MARK:
    //MARK: 加载UI 注：必须在调用 reloadAction 之前调用
    public func excute(_ statue: LoadingStatu) {
        creatLoading(statue)
    }
    
    //MARK:
    //MARK: private
    private func creatLoading(_ statue: LoadingStatu) {
        if loadingView == nil {
            var startY: CGFloat = 0
            if (isKind(of: UITableViewController.self) == true || isKind(of: UICollectionViewController.self) == true) && automaticallyAdjustsScrollViewInsets == false {
                startY = 64
            }
            
            loadingView = LoadingView.init(frame: CGRect.init(x: 0, y: startY, width: PPScreenW, height: loadingViewHeight()))
        }
        if loadingView?.superview == nil {
            self.view.addSubview(loadingView!)
            self.view.bringSubviewToFront(loadingView!)
        }
        
        loadingView!.statue = statue
    }
    
    @IBInspectable private var loadingView: LoadingView? {
        get {
            return objc_getAssociatedObject(self, RuntimeKey.loadingView!) as? LoadingView
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.loadingView!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var reloadAction: Driver<Void> {
        if loadingView == nil {
            fatalError("请在调用此方法之前调用 - excute(_ statue: LoadingStatu)")
        }
        return (loadingView?.reloadButton.rx.tap.asDriver())!
    }
    
    public func toDeinit() {
        objc_removeAssociatedObjects(self)
    }
}

import SnapKit
class LoadingView: UIView {
    
    private let defaultRemindText = "网络消化不良\n检查您的手机是否联网"
    private var startAnimotionDate: Date?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.white
        
        reloadButton.addTarget(self, action: #selector(reloadAction), for: .touchUpInside)
        reloadButton.setTitle("重新加载", for: .normal)
        
        addSubview(reloadButton)
        addSubview(remindTextLabel)
        addSubview(gifView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var statue: LoadingStatu = .loading {
        didSet {
            switch statue {
            case .loading:
                startLoading()
                break
            case .finish:
                successLoading()
                break
            case .failure:
                failureLoading()
                break
            case .failureInfo(let message):
                failureLoading(message)
                break
            }
        }
    }
    
    private func startLoading() {
        startAnimotionDate = Date()
        
        reloadButton.isHidden    = true
        remindTextLabel.isHidden = true
        gifView.isHidden         = false

        gifView.isHidden         = false
    }
    
    private func successLoading() {
        if let startDate = startAnimotionDate {
            if Date().timeIntervalSince(startDate) < 0.25 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) { [unowned self] in
                    self.hiddenLoading()
                }
            }else {
                hiddenLoading()
            }
        }else {
            hiddenLoading()
        }
    }
    
    private func hiddenLoading() {
        reloadButton.isHidden    = true
        remindTextLabel.isHidden = true
        
        gifView.isHidden         = true

        removeFromSuperview()
    }
    
    private func failureLoading(_ remind: String? = nil) {
        remind?.isEmpty == false ? setRemindText(remind!) : setDefatutRemind()
        reloadButton.isHidden    = false
        remindTextLabel.isHidden = false
        
        gifView.isHidden         = true
    }
    
    @objc private func reloadAction() {
        startLoading()
    }
    //MARK:
    //MARK: UI
    public var reloadButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitleColor(RGB(160, 160, 160), for: .normal)
        button.layer.cornerRadius = 5.0
        button.layer.borderColor  = RGB(160, 160, 160).cgColor
        button.layer.borderWidth  = 1.0
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    private var remindTextLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = RGB(160.0, 160.0, 160.0, 1.0)
        label.textAlignment = .center
        return label
    }()
    
    private var gifView: UIImageView = {
        let imageView = UIImageView()
        imageView.loadGif(name: "loading")
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    
    private func setDefatutRemind() {
        let mutableStr = NSMutableAttributedString.init(string: defaultRemindText)
        let dict = [
            NSAttributedString.Key.foregroundColor: RGB(200.0, 200.0, 200.0, 1.0),
            NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)
        ];
        mutableStr.addAttributes(dict, range: NSRange.init(location: 6, length: 11))

        remindTextLabel.text = nil
        remindTextLabel.numberOfLines = 2
        remindTextLabel.attributedText = mutableStr
    }
    
    private func setRemindText(_ text: String) {
        remindTextLabel.numberOfLines = 0
        remindTextLabel.attributedText = nil
        remindTextLabel.text = text
    }
    //MARK:
    //MARK: layout
    override func layoutSubviews() {
        super.layoutSubviews()

        gifView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(CGSize.init(width: 70, height: 70))
        }
        
        remindTextLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(20);
            make.centerY.equalTo(self).offset(-25);
            make.right.equalTo(self).offset(-20)
        }
        
        reloadButton.snp.makeConstraints { make in
            make.top.equalTo(self.remindTextLabel.snp.bottom).offset(15);
            make.centerX.equalTo(self.remindTextLabel);
            make.size.equalTo(CGSize.init(width: 100, height: 35));
        }
    }

}

public enum LoadingStatu {
    case loading
    case finish
    case failure
    case failureInfo(message: String)
}
