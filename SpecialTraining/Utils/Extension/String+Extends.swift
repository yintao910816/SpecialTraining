//
//  NSString+Extends.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/12/7.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation
import UIKit

public let sr_fontName          = "Helvetica Neue"
public let sr_fontSize: CGFloat = 15

// MARK:
// MARK: 字符串size计算
extension String {
    
    func getTextHeigh(fontSize: Float, width: CGFloat, fontName: String = sr_fontName) -> CGFloat {
        
        return self.textSize(fontSize: fontSize, width: width, height: CGFloat(MAXFLOAT), fontName: fontName).height
    }
    
    func getTexWidth(fontSize: Float, height: CGFloat, fontName: String = sr_fontName) -> CGFloat {
        
        return self.textSize(fontSize: fontSize, width: CGFloat(MAXFLOAT), height: height, fontName: fontName).width
    }

    private func textSize(fontSize: Float, width: CGFloat, height: CGFloat, fontName: String) ->CGSize {
    
        let font = UIFont.init(name: fontName, size: CGFloat(fontSize))
        PrintLog("字符串size font为 --- \(font)")
        let size = CGSize(width: width, height: height)
        
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        return self.boundingRect(with: size, options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine, .usesFontLeading], attributes: attributes, context:nil).size
    }
}

// MARK:
// MARK: 字符串操作
extension String {

    public func sr_timeFormat() ->String {
        
        guard let date = stringFormatDate()  else {
            return ""
        }
        
        let today = Date()
        // 计算时间差
        let timeInterval = today.timeIntervalSince(date)
        
        let cal = Calendar.current
        let todate = Date.init(timeIntervalSinceNow: timeInterval)
        let components: Set = [
            Calendar.Component.year,
            Calendar.Component.month,
            Calendar.Component.day,
            Calendar.Component.hour,
            Calendar.Component.minute,
            Calendar.Component.second
        ]
        
        let gap = cal.dateComponents(components, from: today, to: todate)
        if abs(gap.year ?? 0) > 0 {
            return "\(abs(gap.year!))年前"
        }else if abs(gap.month ?? 0) > 0 {
            return "\(abs(gap.month!))个月前"
        }else if abs(gap.day ?? 0) > 0 {
            return "\(abs(gap.day!))天前"
        }else if abs(gap.hour ?? 0) > 0 {
            return "\(abs(gap.hour!))小时前"
        }else if abs(gap.minute ?? 0) > 0 {
            return "\(abs(gap.minute!))分钟前"
        }
        
        return "刚刚"
    }
    
    public func getDayDiff(more: Bool) -> String {
     
        guard let date = stringFormatDate()  else {
            return ""
        }
        
        let today = Date()
        // 计算时间差
        let timeInterval = today.timeIntervalSince(date)
        
        let cal = Calendar.current
        let todate = Date.init(timeIntervalSinceNow: timeInterval)
        let components: Set = [
                                Calendar.Component.year,
                                Calendar.Component.month,
                                Calendar.Component.day,
                                Calendar.Component.hour,
                                Calendar.Component.minute,
                                Calendar.Component.second
                              ]

        let gap = cal.dateComponents(components, from: today, to: todate)
        if abs(gap.day!) > 0 {
            if abs(gap.day!) > 3 {
                let timeArr = self.components(separatedBy: " ")
                let days = timeArr.first?.components(separatedBy: "-")
                let times = timeArr.last?.components(separatedBy: ":")
                
                let year = days?[0]
                let month = days?[1]
                let day = days?[2]
                let hh = times?[0]
                let mm = times?[1]
                let ss = times?[2]

                if abs(gap.year!) > 0 {
                    if more {
                        return self
                    }
                    return ("\(year!)-\(month!)-\(day!)")
                }else {
                
                    if more {
                        return ("\(month!)-\(day!) \(hh!):\(mm!):\(ss!)")
                    }
                    return "\(month!)-\(day!)"
                }

            }else { return "\(abs(gap.day!))天前" }
        }else if abs(gap.hour!) > 0 {
            return "\(abs(gap.hour!))小时前"
        }else {
        
            if abs(gap.minute!) == 0 {
                return "刚刚"
            }
            return "\(abs(gap.minute!))小时前"
        }
    }
    
    public func timeSeprate() -> String {    
        let timeArr = self.components(separatedBy: " ")
        let detailTime = timeArr.first?.components(separatedBy: "-")
        
        let year = detailTime?[0]
        let month = detailTime?[1]
        let day = detailTime?[2]
        
        let now = Date()
        let calendar = NSCalendar.current
        let dateCompont = calendar.dateComponents([Calendar.Component.year], from: now)
        
        let curYear = dateCompont.year
        if Int(year!)! != curYear! {
            return "\(year!)年\(month!)月\(day!)日 \(timeArr.last!)"
        }
        return  "\(month!)月\(day!)日"
    }
    
    // eg:7.9 18:30
    public func timeSeprate1() -> String {
        
        guard let date = stringFormatDate()  else {
            return ""
        }
        
        let timeArr = self.components(separatedBy: " ")
        let days = timeArr.first?.components(separatedBy: "-")
        let times = timeArr.last?.components(separatedBy: ":")
        
//        let year = days?[0]
        let month = days?[1]
        let day = days?[2]
        let hh = times?[0]
        let mm = times?[1]
//        let ss = times?[2]
        
        return "\(month!).\(day!) \(hh!):\(mm!)"
    }
    
}

// MARK:
// MARK: NSAttributedString
extension String {
    
    /// 同一lable种现实两种不同颜色字体
    ///
    public func attributed(_ range: NSRange, _ color: UIColor, _ font: UIFont? = nil) ->NSAttributedString {
        
        let muString = NSMutableAttributedString.init(string: self)
        var dic: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : color]
        if font != nil {
            dic[NSAttributedString.Key.font] = font
        }
        muString.addAttributes(dic, range: range)
        return muString
    }
    
    /// 同一lable种现实不同颜色字体
    ///
    public func attributed(_ rangs: [NSRange], color colors: [UIColor] = [], font fonts: [UIFont] = []) ->NSAttributedString {
        let muString = NSMutableAttributedString.init(string: self)
        for idx in 0 ..< colors.count {
            muString.addAttribute(NSAttributedString.Key.foregroundColor, value: colors[idx], range: rangs[idx])
        }
        for idx in 0 ..< fonts.count {
            muString.addAttribute(NSAttributedString.Key.font, value: fonts[idx], range: rangs[idx])
        }

        return muString
    }
}

extension String { /**时间与日期*/

    public func stringFormatDate() ->Date?{
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = format.date(from: _transform())
        return date
    }
    
    fileprivate func _transform() -> String {
        
        if components(separatedBy: " ").count == 1{
            return appending(" 00:00:00")
        }
        return self
    }
}

extension String {
    
    var md5: String {
        let str = cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate()
        
        return String(format: hash as String)
    }
    
}

extension String {
    
    func replacePhone() -> String {
        let start = index(startIndex, offsetBy: 3)
        let end = self.index(startIndex, offsetBy: 7)
        let range = Range(uncheckedBounds: (start, end))
        return replacingCharacters(in: range, with: "****")
    }
    
}
