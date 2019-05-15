//
//  ChatLeftView.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/20.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import SnapKit

class ChatLeftView: UIView {

    @IBOutlet weak var textOutlet: YYLabel!
    @IBOutlet weak var timeOutlet: UILabel!
    @IBOutlet var contentView: UIView!

    @IBOutlet weak var iconOutlet: UIButton!
    
    @IBOutlet weak var paopaoWidthCns: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func awakeFromNib() {
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        contentView = (Bundle.main.loadNibNamed("ChatLeftView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints{
            $0.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var model: ChatTextModel! {
        didSet {
            timeOutlet.text = model.messageTime
            textOutlet.textLayout = model.textContentLayout
//            iconOutlet.setImage(model.iconStr, .userIcon)
            paopaoWidthCns.constant = model.textContentLayout.textBoundingSize.width + 20
        }
    }
}
