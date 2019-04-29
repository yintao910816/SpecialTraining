//
//  MineHeaderCollectionReusableView.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/18.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MineHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet var contentView: UICollectionReusableView!
    @IBOutlet weak var iconOutlet: UIButton!
    @IBOutlet weak var nickNameOutlet: UILabel!

    @IBOutlet weak var bgColorView: UIView!
    @IBOutlet weak var iconTopCns: NSLayoutConstraint!
    @IBOutlet weak var bgColorHeightCns: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    
    weak var delegate: MineHeaderActions?

    @IBAction func actions(_ sender: UIButton) {
        switch sender.tag {
        case 500:
            delegate?.gotoMineInfo()
        case 501:
            delegate?.gotoSetting()
        case 502:
            delegate?.gotoMineCourse()
        case 503:
            delegate?.gotoMineAccount()
        case 504:
            delegate?.gotoMineRecommend()
        default:
            break
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        contentView = (Bundle.main.loadNibNamed("MineHeaderCollectionReusableView", owner: self, options: nil)?.first as! UICollectionReusableView)
        addSubview(contentView)
        layoutIfNeeded()

        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
        
        iconOutlet.imageView?.contentMode = .scaleAspectFill
        
        iconTopCns.constant += UIDevice.current.isX ? 44 : 20
        bgColorHeightCns.constant += UIDevice.current.isX ? 44 : 20
        
        bgColorView.layer.insertSublayer(STHelper.themeColorLayer(frame: .init(x: 0, y: 0, width: frame.width, height: bgColorHeightCns.constant)), at: 0)
        
        setupData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupData() {
        NotificationCenter.default.rx.notification(NotificationName.user.loginSuccess)
            .subscribe(onNext: { [weak self] _ in
                self?.iconOutlet.setImage(UserAccountServer.share.loginUser.member.headimgurl)
                self?.nickNameOutlet.text = UserAccountServer.share.loginUser.member.nickname
            })
            .disposed(by: disposeBag)
        
        iconOutlet.setImage(UserAccountServer.share.loginUser.member.headimgurl)
        nickNameOutlet.text = UserAccountServer.share.loginUser.member.nickname
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        cornerLayer.frame = shadowView.bounds
//        shadowLayer.frame = .init(x: shadowView.x, y: shadowView.y + 10, width: shadowView.width, height: shadowView.height - 10)
    }
}

protocol MineHeaderActions: class {
    
    func gotoMineInfo()
    
    func gotoSetting()
    
    func gotoMineCourse()
    
    func gotoMineAccount()
    
    func gotoMineRecommend()
}
