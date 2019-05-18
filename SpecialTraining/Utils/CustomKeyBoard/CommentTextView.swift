//
//  EmojiTextFiledView.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/6/13.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

class CommentTextView: UIView  {
    private let defaultFontSize: CGFloat = 15
    private let defaultTextColor = UIColor.black

    fileprivate var inputTf         : EmojTextView!
    private var limitChartsLabel: UILabel!
    // 选择emoji表情
    private var emojiButton     : UIButton!
    // 选择图片和t其它内容
    private var otherSendButton : UIButton!
    // 切换语音发送
    private var exchangeVoiceButton : UIButton!
    // 录音按钮
    private var audioButton: ChatToolBarAudioButton!

    private var progressView: UIProgressView!
    
    private var topLine         : UIView!

    public var delegate: CommentTextViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    public func tf_becomeFirstResponder() {
        if inputTf.isFirstResponder == false {
            PrintLog("激活键盘")
            inputTf.becomeFirstResponder()
        }
    }
    
    //MARK:
    //MARK: UI 设置
    private func setupUI() {
        topLine = UIView()
        topLine.backgroundColor = RGB(220, 220, 220)
        
        progressView = UIProgressView.init()
        progressView.trackTintColor = UIColor.groupTableViewBackground
        progressView.progressTintColor = UIColor.red
        
        // 显示语音播放
        exchangeVoiceButton = UIButton.init(type: .system)
        exchangeVoiceButton.tintColor = UIColor.clear
        exchangeVoiceButton.setBackgroundImage(UIImage.init(named: "voice_first_frame_left"), for: .normal)
        exchangeVoiceButton.addTarget(self, action: #selector(exchangeRecordAudio), for: .touchUpInside)
        
        audioButton = ChatToolBarAudioButton.init()
        audioButton.delegate = self
        audioButton.isHidden = true
        
        inputTf = EmojTextView()
        inputTf.font = UIFont.systemFont(ofSize: defaultFontSize)
        inputTf.textColor = defaultTextColor
        inputTf.returnKeyType = .send
        inputTf.tvdelegate = self
        inputTf.mediaDelegate = self
        
        limitChartsLabel = UILabel()
        limitChartsLabel.textColor = defaultTextColor
        
        emojiButton = UIButton.init(type: .system)
        emojiButton.tintColor = UIColor.clear
        emojiButton.setBackgroundImage(UIImage.init(named: "keyboard_face"), for: .normal)
        emojiButton.addTarget(self, action: #selector(showEmojiView(_:)), for: .touchUpInside)
        
        otherSendButton    = UIButton.init(type: .custom)
        otherSendButton.setImage(UIImage.init(named: "chat_add_media"), for: .normal)
        otherSendButton.clipsToBounds      = true
        otherSendButton.addTarget(self, action: #selector(showMediaView(_:)), for: .touchUpInside)
        
        addSubview(topLine)
        insertSubview(progressView, aboveSubview: topLine)
        addSubview(exchangeVoiceButton)
        addSubview(inputTf)
        addSubview(otherSendButton)
        addSubview(emojiButton)
        addSubview(limitChartsLabel)
        insertSubview(audioButton, aboveSubview: inputTf)

        topLine.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(1)
        }
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(self)
            $0.left.equalTo(self)
            $0.right.equalTo(self)
            $0.height.equalTo(2)
        }
        
        exchangeVoiceButton.snp.makeConstraints { make in
            make.left.equalTo(self).offset(10)
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(25)
            make.width.equalTo(exchangeVoiceButton.snp.height).multipliedBy(1)
        }

        otherSendButton.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(self.height - 20)
            make.width.equalTo(otherSendButton.snp.height)
        }

        emojiButton.snp.makeConstraints { make in
            make.right.equalTo(otherSendButton.snp.left).offset(-7)
            make.centerY.equalTo(otherSendButton.snp.centerY)
            make.height.equalTo(otherSendButton.snp.height)
            make.width.equalTo(otherSendButton.snp.height)
        }
        
        limitChartsLabel.snp.makeConstraints { make in
            make.right.equalTo(emojiButton.snp.left).offset(-10)
            make.centerY.equalTo(emojiButton.snp.centerY)
        }
        
        inputTf.snp.makeConstraints { make in
            make.left.equalTo(exchangeVoiceButton.snp.right).offset(5)
            make.right.equalTo(limitChartsLabel.snp.left).offset(-10)
            make.centerY.equalTo(limitChartsLabel.snp.centerY)
            make.height.equalTo(otherSendButton.snp.height)
        }
        
        audioButton.snp.makeConstraints { $0.edges.equalTo(inputTf) }
    }
    
    public var textFont: CGFloat? {
        didSet {
            inputTf.font = UIFont.systemFont(ofSize: (textFont ?? defaultFontSize))
            limitChartsLabel.font = UIFont.systemFont(ofSize: (textFont ?? defaultFontSize))
        }
    }
    
    public var textColor: UIColor? {
        didSet {
            inputTf.textColor = (textColor ?? defaultTextColor)
            limitChartsLabel.textColor = (textColor ?? defaultTextColor)
        }
    }

    public var placeholder: String? {
        didSet {
            inputTf.placeholder = placeholder
        }
    }
    
    public var limitCount: Int? = NSNotFound {
        didSet {
            layoutIfNeeded()
        }
    }
    
    // 提交
    private func submit() {
        inputTf.resignFirstResponder()
        delegate?.submitComment(inputTf.e_totleText)
        inputTf.text = nil
        inputTf.placeholder = placeholder
    }
    
    // 语音录制切换
    @objc private func exchangeRecordAudio() {
        exchangeVoiceButton.isSelected = !exchangeVoiceButton.isSelected
        audioButton.isHidden = !exchangeVoiceButton.isSelected
    }
    
    @objc func showEmojiView(_ button: UIButton) {
        if button.isSelected == true {
            inputTf.e_emojiHidden(reload: true)
        }else {
            inputTf.e_emojiShow()
        }
        button.isSelected = !button.isSelected
    }
    
    @objc func showMediaView(_ button: UIButton) {
        if button.isSelected == true {
            inputTf.mediaHidden(reload: true)
        }else {
            inputTf.mediaShow()
        }
        button.isSelected = !button.isSelected
    }
    
    //MARK:
    //MARK: layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if limitCount == NSNotFound {
            limitChartsLabel.snp.remakeConstraints({ make in
                make.right.equalTo(emojiButton.snp.left).offset(-10)
                make.centerY.equalTo(emojiButton.snp.centerY)
                make.width.equalTo(0)
            })
            
            inputTf.snp.updateConstraints({ make in make.right.equalTo(limitChartsLabel.snp.left) })
        }else {
            limitChartsLabel.snp.remakeConstraints({ make in
                make.right.equalTo(emojiButton.snp.left).offset(-10)
                make.centerY.equalTo(emojiButton.snp.centerY)
            })
            
            inputTf.snp.updateConstraints({ make in make.right.equalTo(limitChartsLabel.snp.left).offset(-10) })
        }
    }
    
}

extension CommentTextView: PlaceholderTextViewDelegate {
    
    //MARK:
    //MARK: UITextViewDelegate
    func tv_textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if let r = delegate?.tv_textViewShouldBeginEditing(self) {
            return r
        }
        return true
    }
    
    func tv_textViewDidEndEditing(_ textView: UITextView) {
        inputTf.e_emojiHidden(reload: true)
        delegate?.tv_textViewDidEndEditing(self)
    }
    
    func tv_textView(_ textView: PlaceholderTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            submit()
            inputTf.e_emojiHidden(reload: true)
        }
        return true
    }

}

extension CommentTextView: DPChatToolBarAudioDelegate {
    
    func dpAudioRecordingFinish(with audioData: Data!, withDuration duration: UInt) {
        delegate?.recordFinish(with: audioData, duration: Int(duration))
        progressView.setProgress(0, animated: true)
    }
    
    func dpAudioSpeakPower(_ power: Float) {
        progressView.setProgress(power, animated: true)
    }
    
    func dpAudioRecordingFail(_ reason: String!) {
        NoticesCenter.alert(title: "录制失败", message: reason)
        progressView.setProgress(0, animated: true)
    }
    
    func dpAudioStartRecording(_ isRecording: Bool) {
        
    }
}

extension CommentTextView: EmojTextViewDelegate {
    
    func mediaSelected(idx: Int) {
        delegate?.mediaSelected(idx: idx)
    }
}

protocol CommentTextViewDelegate {
    
    func tv_textViewShouldBeginEditing(_ textView: CommentTextView) -> Bool
    
    func tv_textViewDidEndEditing(_ textView: CommentTextView)
    
    func submitComment(_ content: String?)
    
    func mediaSelected(idx: Int)
    
    func recordFinish(with data: Data, duration: Int)
}
