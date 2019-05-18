//
//  EmojTextView.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/5/12.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

class EmojTextView: PlaceholderTextView, ToolBarEvent, EmojiOperation, EmojiInputProtocol {
    
    private var oldFont: UIFont!
    private var emojiView: EmojView!
    private var emojiToolBar: EmjoToolBar!
    
    private var mediaView: MedieView!
    // 表情大小
    public var e_emojiSize: CGSize!
    public var e_topInset: CGFloat = -4
    
    weak var mediaDelegate: EmojTextViewDelegate?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        _init()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        _init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func _init() {
        e_emojiSize = CGSize.init(width: e_font.lineHeight, height: e_font.lineHeight)
        oldFont = e_font
        super.font = oldFont
        
        setupView()
    }
    
    private func setupView() {
        emojiView = EmojView.init(emjos: (EmojImage.emjoSource(.custom) ?? [String]()),
                                 emjoType: .custom)
        emojiView.delegate = self
        
        mediaView = MedieView.init(datasource: ["chat_add_image"])
        mediaView.delegate = self
    }
    
    private func setupEmojiToolBar() {
        if emojiToolBar == nil {
            emojiToolBar = EmjoToolBar.init(frame: CGRect.init(x: 0, y: 0, width: PPScreenW, height: 45))
            emojiToolBar.delegate = self
        }
        
        if e_showToolBar == true { inputAccessoryView = emojiToolBar }
        else { inputAccessoryView = nil }
    }
    
    private func resetTextStyle() {
        let wholeRange = NSMakeRange(0, textStorage.length)
        textStorage.removeAttribute(NSAttributedString.Key.font, range: wholeRange)
        textStorage.addAttribute(NSAttributedString.Key.font, value: oldFont, range: wholeRange)
        font = oldFont
    }
    
    //MARK:
    //MARK: 属性设置
    /// 字体
    var e_font: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            oldFont = e_font
            super.font = e_font
        }
    }
    
    /// 是否显示键盘工具栏
    var e_showToolBar: Bool = false {
        didSet {
            setupEmojiToolBar()
        }
    }
    
    //MARK:
    //MARK: EmojiInputProtocol
    func e_emojiShow() {
        inputView = emojiView
        reloadInputViews()
        
        if isFirstResponder == false { becomeFirstResponder() }
    }

    func e_emojiHidden(reload: Bool) {
        inputView = nil
        if reload == true { reloadInputViews() }
    }
    
    func e_deleteText() {
        if selectedRange.location > 0 { textStorage.replaceCharacters(in: NSMakeRange(selectedRange.location - 1, 1), with: "") }
    }
    
    func e_insertEmoji(emojName: String) {
        let emojiTextAttachment = EmojTextAttachment.init(EmojImage.removeSuffix(emojName), e_emojiSize, e_topInset)
        emojiTextAttachment.image = EmojImage.emojImage(emojName)
        //插入表情
        textStorage.insert(NSAttributedString.init(attachment: emojiTextAttachment),
                           at: selectedRange.location)
        //移动光标
        selectedRange = NSMakeRange(selectedRange.location + 1, selectedRange.length)
        //插入表情之后需要重新设置字体样式，不然字体大小会改变
        resetTextStyle()
    }
    
    var e_totleText: String? {
        let resultString = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if resultString.count == 0 {
            return nil
        }else {
            return textStorage.plainString()
        }
    }
    
    func mediaShow() {
        inputView = mediaView
        reloadInputViews()
        
        if isFirstResponder == false { becomeFirstResponder() }
    }
    
    func mediaHidden(reload: Bool) {
        inputView = nil
        if reload == true { reloadInputViews() }
    }
    
    //MARK:
    //MARK: ToolBarEvent
    func toolBarEevnt(eventType: ToolBarEventType, button: UIButton) {
        switch eventType {
        case .emoji:
            button.isSelected == true ? e_emojiShow() : e_emojiHidden(reload: true)
            break
        default:
            break
        }
    }
    
    //MARK:
    //MARK: EmojiOperation
    func inputEmoj(emojName: String) { e_insertEmoji(emojName: emojName) }
    
    func deleteEmoj(emojName: String) { e_deleteText() }
        
}

extension EmojTextView: MediaProtocol {
    
    func mediaItem(selected idx: Int) {
        mediaDelegate?.mediaSelected(idx: idx)
    }
}

protocol EmojTextViewDelegate: class {
    
    func mediaSelected(idx: Int)
}
