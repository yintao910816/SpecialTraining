//
//  EmojUtls.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/5/12.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

enum EmjoType {

    case system
    case custom
}

class EmojImage {
    
    /// 获取emjo图片名字
    ///
    /// - Parameter type: EmjoType
    /// - Returns: emjo图片名字
    public static func emjoSource(_ type: EmjoType) ->[String]? {
        switch type {
        case .system:
            return nil
        case .custom:
            let path = Bundle.main.path(forResource: "EmojiSoruce", ofType: "plist", inDirectory: "Resources.bundle")!
            let emojis = NSArray.init(contentsOfFile: path)
            return emojis as? [String]
        }
    }
    
    /// 返回emoj图片
    ///
    /// - Parameter name: emoj图片名字
    /// - Returns: emoj图片
    public static func emojImage(_ name: String) ->UIImage? {
        let path = Bundle.main.path(forResource: name, ofType: "png", inDirectory: "Resources.bundle/emoji")!
//        let path = Bundle.main.bundlePath.appending("/\(name)")
        return UIImage.init(contentsOfFile: path)
    }
    
    /// 自定义的表情，去掉图片名字的后缀,并加上"[]"
    ///
    /// - Parameter imageName: 图片名字
    /// - Returns: <#return value description#>
    public static func removeSuffix(_ imageName: String) ->String {
        var returnString = imageName
        if imageName.contains("_thumb") {
            returnString = imageName.replacingOccurrences(of: "_thumb", with: "")
        }
        return "[em=\(returnString)]"
    }
    
    /// 输入表情字符拼接
    ///
    /// - Parameters:
    ///   - text: <#text description#>
    ///   - replaceText: <#replaceText description#>
    /// - Returns: <#return value description#>
    public static func inputEmoj(_ text: String, _ replaceText: String) ->String {
        return text.appending(replaceText)
    }
}


protocol EmojiHander {
    
    func transform(_ emojiString: String, _ scale: CGFloat) ->NSMutableAttributedString
}


extension EmojiHander {
    
    /// 创建字符串的emoji
    fileprivate func emoji(_ emojiString: String, _ scale: CGFloat) -> NSMutableAttributedString{
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: imagePath(emojiString))) else { return NSMutableAttributedString.init() }
        let image = YYImage.init(data: data, scale: scale)
        image?.preloadAllAnimatedImageFrames = true
        
        let imageView = YYAnimatedImageView.init(image: image)
        let attachText = NSMutableAttributedString.yy_attachmentString(withContent: imageView,
                                                                    contentMode: .scaleAspectFill,
                                                                    attachmentSize: imageView.size,
                                                                    alignTo: UIFont.systemFont(ofSize: 15),
                                                                    alignment: .center)
        return attachText
    }
    
    /// 获取图片地址
    fileprivate func imagePath(_ emojiString: String) ->String {
        
        let strings = emojiString.components(separatedBy: "=")
        let name    = strings.last! + "_thumb"
        return Bundle.main.path(forResource: name, ofType: "png", inDirectory: "Resources.bundle/emoji") ?? ""
    }
    
    fileprivate func deleteCharts(_ string: String, _ containString: String) ->String {
        
        if string.isEmpty {
            return ""
        }else {
            
            let nospaceString = string.trimmingCharacters(in: CharacterSet.whitespaces)
            //以"[]"拆分字符串
            let strings = nospaceString.components(separatedBy: CharacterSet.init(charactersIn: "[]"))
            
            if strings.count <= 1 { return nospaceString }
            
            var retString: String = ""
            for idx in 0 ..< strings.count {
                
                let subString = strings[idx]
                if subString.contains(containString) == false {
                    //去除标识字符
                    retString = retString.appending(subString)
                }
            }
            return retString
        }
    }
}

extension EmojiHander {
    
    /// 会设置颜色
    ///
    /// - Parameters:
    ///   - emojiString: <#emojiString description#>
    ///   - scale: <#scale description#>
    /// - Returns: <#return value description#>
    func transform(_ emojiString: String, _ scale: CGFloat) ->NSMutableAttributedString {
        
        let contentString = NSMutableAttributedString.init()
        //去除首字符空格
        let noSpaceString = emojiString.trimmingCharacters(in: CharacterSet.whitespaces)
        if noSpaceString.contains("em=") {
            //有表情,把字符串以emoji符号拆分
            let strings = noSpaceString.components(separatedBy: CharacterSet.init(charactersIn: "[]"))
            for idx in 0 ..< strings.count {
                
                let subString = strings[idx]
                if subString.contains("em=") {
                    contentString.append(emoji(subString, 3.0))
                }else{
                    contentString.yy_appendString(subString)
                }
            }
        }else {
            contentString.yy_appendString(emojiString)
        }
        return contentString
    }
}

