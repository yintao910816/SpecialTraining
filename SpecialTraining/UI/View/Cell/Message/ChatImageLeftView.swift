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
            contentImageOutlet.setImage(nil, for: .normal)
            iconOutlet.setImage(model.iconStr, .userIcon)
            timeOutlet.text = model.messageTime
            
            if let img = model.image {
                contentImageOutlet.setImage(img, for: .normal)
            }else {
                EMClient.shared()?.chatManager.downloadMessageThumbnail(model.message, progress: nil, completion: { [weak self] (msg, error) in
                    if error == nil && msg != nil {
                        self?.model.setImage(emsg: msg!)
                        self?.contentImageOutlet.setImage(self?.model.image, for: .normal)
                    }
                })
            }

            paopaoWidthCns.constant = model.width + 20
            paopaoHeightCns.constant = model.height + 20
        }
    }
    
    deinit {
        PrintLog("释放了 \(self)")
    }

}
