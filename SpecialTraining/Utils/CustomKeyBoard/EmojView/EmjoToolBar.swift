//
//  EmjoToolBar.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/5/12.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

class EmjoToolBar: UIView {

    public var delegate: ToolBarEvent?
    @IBOutlet private weak var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        _init()
    }

    private func _init() {
        contentView = loadXIB(EmjoToolBar.self)
        addSubview(contentView)
        
        contentView.snp.makeConstraints { make in make.edges.equalTo(self) }
    }
    
    @IBAction func action(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.toolBarEevnt(eventType: .emoji ,button: sender)
    }
}

public protocol ToolBarEvent {
    
    func toolBarEevnt(eventType: ToolBarEventType, button: UIButton)
}

public enum ToolBarEventType {
    case emoji
    case other
}
