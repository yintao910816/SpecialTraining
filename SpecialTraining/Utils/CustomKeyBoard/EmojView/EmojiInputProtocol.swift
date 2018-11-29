//
//  EmojiInputProtocol.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/6/13.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation

protocol EmojiInputProtocol {
    
    /// 显示emoji键盘
    func e_emojiShow()
    
    /// 隐藏emoji键盘
    ///
    /// - Parameter reload: 隐藏时是否需要刷新键盘
    func e_emojiHidden(reload: Bool)
    
    /// 点击emoji键盘上的删除
    func e_deleteText()
    
    /// 输入一个emoji表情
    ///
    /// - Parameter emojName: emoji表情图片名字
    func e_insertEmoji(emojName: String)
    
    /// 显示图片选择和和其它文件发送的界面
    ///
    /// - Parameter emojName: emoji表情图片名字
    func mediaShow()
    
    /// 隐藏多功能键盘
    ///
    /// - Parameter reload: 隐藏时是否需要刷新键盘
    func mediaHidden(reload: Bool)    
}

extension EmojiInputProtocol {

    /// 返回所有文字
    var e_totleText: String? {
        get {
            return nil
        }
    }
}
