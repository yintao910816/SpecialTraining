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
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var contactsOutlet: UIButton!
    
    @IBOutlet weak var topCns: NSLayoutConstraint!
    @IBOutlet weak var bgViewHeightCns: NSLayoutConstraint!
    
    override init() {
        super.init()
        contentView = (Bundle.main.loadNibNamed("MessageHeaderView", owner: self, options: nil)?.first as! UIView)

        if UIDevice.current.isX {
            var rect = contentView.frame
            rect.size.height += LayoutSize.topVirtualArea
            contentView.frame = rect
            
            topCns.constant += LayoutSize.topVirtualArea
            bgViewHeightCns.constant += LayoutSize.topVirtualArea
        }
        
        shadowView.set(cornerAndShaow: cornerView)
    }
}
