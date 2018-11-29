//
//  ChatImageLeftView.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/21.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import Kingfisher

class ChatImageLeftView: UIView {

    @IBOutlet weak var timeOutlet: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var iconOutlet: UIButton!
    @IBOutlet weak var contentImageOutlet: UIButton!
    
    @IBOutlet weak var paopaoWidthCns: NSLayoutConstraint!
    @IBOutlet weak var paopaoHeightCns: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func awakeFromNib() {
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        contentView = (Bundle.main.loadNibNamed("ChatImageLeftView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints{
            $0.edges.equalTo(UIEdgeInsets.zero)
        }        
    }

    var model: ChatImageModel! {
        didSet {
            iconOutlet.setImage(model.iconStr, .userIcon)

            timeOutlet.text = model.messageTime

            PrintLog(model.thumbnailLocalPath)
            PrintLog(model.thumbnailRemotePath)
            
            _ = Create(imageTask: model.thumbnailRemotePath)
                .subscribe(onNext: { [weak self] (image, url) in
                    self?.contentImageOutlet.setImage(image, for: .normal)
                    }, onError: { error in
                        PrintLog(error)
                })
            
            paopaoWidthCns.constant = model.width + 20
            paopaoHeightCns.constant = model.height + 20
        }
    }
    
    deinit {
        PrintLog("释放了 \(self)")
    }

}
