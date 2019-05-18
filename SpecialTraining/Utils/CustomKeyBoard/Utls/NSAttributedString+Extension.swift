//
//  NSAttributedString+Extension.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/5/12.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation

extension NSAttributedString {
    
    /// 最终纯文本
    public final func plainString() ->String {
        let plainString = NSMutableString.init(string: self.string)
        var base: Int = 0
        self.enumerateAttribute(NSAttributedString.Key.attachment,
                                in: NSMakeRange(0, self.length),
                                options: .longestEffectiveRangeNotRequired) { va, range, error in
                                    
                                    if va as? EmojTextAttachment != nil {
                                        let attachment = va as! EmojTextAttachment
                                        plainString.replaceCharacters(in: NSMakeRange(range.location + base, range.length),
                                                                      with: attachment.emojiTag)
                                        base += attachment.emojiTag.count - 1;
                                    }
        }
        
        return plainString as String
    }
}
