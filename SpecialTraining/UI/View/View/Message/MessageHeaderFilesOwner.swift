//
//  MessageHeaderFilesOwner.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/19.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class MessageHeaderFilesOwner: BaseFilesOwner {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var topCns: NSLayoutConstraint!
    override init() {
        super.init()
        contentView = (Bundle.main.loadNibNamed("MessageHeaderView", owner: self, options: nil)?.first as! UIView)

        if UIDevice.current.isX {
            var rect = contentView.frame
            rect.size.height += LayoutSize.topVirtualArea
            contentView.frame = rect
            
            topCns.constant += LayoutSize.topVirtualArea
        }
    }
}
