//
//  MessageListCell.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/19.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class MessageListCell: BaseTBCell {

    struct Frame {
        // 文字内容布局宽度
        static let textContentPrepareWidth: CGFloat = PPScreenW - 12 - 10 - 12
    }
    
    @IBOutlet weak var iconOutlet: UIImageView!
    @IBOutlet weak var nickNameOutlet: UILabel!
    @IBOutlet weak var timeOutlet: UILabel!
    @IBOutlet weak var messageOutlet: YYLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: ChatListModel! {
        didSet {
            nickNameOutlet.text       = model.userName
            messageOutlet.textLayout  = model.textContentLayout
            timeOutlet.text           = model.time
            iconOutlet.setImage(model.userIcon, .userIcon)
        }
    }
    
}
