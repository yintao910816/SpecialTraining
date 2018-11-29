//
//  PlaceholderTextView.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/4/28.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

class PlaceholderTextView: UITextView, UITextViewDelegate {
    
    
    weak var tvdelegate: PlaceholderTextViewDelegate?
    
    fileprivate let placeholderColor = UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1)
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        _initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        _initialize()
    }
    
    private func _initialize() {
        self.delegate = self
        self.showsVerticalScrollIndicator   = false
        self.showsHorizontalScrollIndicator = false
        self.returnKeyType                  = .done
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = placeholderColor
        addSubview(placeholderLabel)
    }
    
    private var placeholderLabel: UILabel = {
        let lbl = UILabel.init()
        lbl.textAlignment = .natural
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    // 水印文字是否居中显示
    var placeholderCenter: Bool! = false {
        didSet {
            if placeholderCenter == true {
                placeholderLabel.snp.remakeConstraints({ make in
                    make.centerY.equalTo(self.snp.centerY)
                    make.left.equalTo(self).offset(5)
                    make.right.equalTo(self).offset(-5)
                })
            }else {
                placeholderLabel.snp.remakeConstraints { make in
                    make.left.equalTo(self).offset(5)
                    make.right.equalTo(self).offset(-5)
                    make.top.equalTo(self).offset(5)
                    make.bottom.equalTo(self).offset(-5)
                }
            }
        }
    }
    
    override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }

    //MARK:
    //MARK: UITextViewDelegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        placeholderLabel.isHidden = true
        return tvdelegate?.tv_textViewShouldBeginEditing(textView) ?? true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            placeholderLabel.isHidden = false
        }else {
            placeholderLabel.isHidden = true
        }
        
        tvdelegate?.tv_textViewDidEndEditing(textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if text == "\n" {
            placeholderLabel.isHidden = false
            textView.resignFirstResponder()
        }
        return tvdelegate?.tv_textView(self, shouldChangeTextIn: range, replacementText: text) ?? true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        placeholderLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
            make.top.equalTo(self).offset(5)
            make.bottom.equalTo(self).offset(-5)
        }
    }
}

protocol PlaceholderTextViewDelegate: class {
    
    func tv_textView(_ textView: PlaceholderTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    
    func tv_textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    
    func tv_textViewDidEndEditing(_ textView: UITextView)
}
