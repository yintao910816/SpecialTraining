//
//  MineHeaderCollectionReusableView.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/18.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import SnapKit

class MineHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet var contentView: UICollectionReusableView!
    @IBOutlet weak var bgColorView: UIView!
    @IBOutlet weak var iconTopCns: NSLayoutConstraint!
    @IBOutlet weak var bgColorHeightCns: NSLayoutConstraint!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var cornerView: UIView!

    weak var delegate: MineHeaderActions?

    @IBAction func actions(_ sender: UIButton) {
        switch sender.tag {
        case 500:
            delegate?.gotoMineInfo()
        case 501:
            delegate?.login()
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
        
        iconTopCns.constant += UIDevice.current.isX ? 44 : 20
        bgColorHeightCns.constant += UIDevice.current.isX ? 44 : 20
        
        bgColorView.layer.insertSublayer(STHelper.themeColorLayer(frame: .init(x: 0, y: 0, width: frame.width, height: bgColorHeightCns.constant)), at: 0)
        
        shadowView.set(cornerAndShaow: cornerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        cornerLayer.frame = shadowView.bounds
//        shadowLayer.frame = .init(x: shadowView.x, y: shadowView.y + 10, width: shadowView.width, height: shadowView.height - 10)
    }
}

protocol MineHeaderActions: class {
    
    func gotoMineInfo()
    
    func login()
    
    func gotoMineCourse()
    
    func gotoMineAccount()
    
    func gotoMineRecommend()
}
