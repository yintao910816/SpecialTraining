//
//  EmojiTextField.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/6/13.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

class EmojiTextField: UITextField, EmojiInputProtocol {
    
    func mediaShow() {
        
    }
    
    func mediaHidden(reload: Bool) {
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK:
    //MARK: EmojiInputProtocol
    /// 显示emoji键盘
    func e_emojiShow() {
    
    }
    
    /// 隐藏emoji键盘
    ///
    /// - Parameter reload: 隐藏时是否需要刷新键盘
    func e_emojiHidden(reload: Bool) {
    
    }
    
    /// 点击emoji键盘上的删除
    func e_deleteText() {

    }
    
    /// 输入一个emoji表情
    ///
    /// - Parameter emojName: emoji表情图片名字
    func e_insertEmoji(emojName: String) {
    
    }

}
