//
//  ConversationUtils.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/21.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation

class ConversationUtil {
    
    // 会话列表最后一条消息的时间
    class func latestMessageTime(conversationModel: EMConversation) ->String {
        var lastestMessageTime = ""
        if let lastMessage = conversationModel.latestMessage {
            var timeInterval = lastMessage.timestamp
            if timeInterval > 140000000000 {
                timeInterval = timeInterval / 1000
            }
            let formatter = DateFormatter.init()
            formatter.dateFormat = "YYYY-MM-dd"
            lastestMessageTime = formatter.string(from: Date.init(timeIntervalSince1970: TimeInterval(timeInterval)))
        }
        return lastestMessageTime
    }

    // 聊天界面时间
    class func messageSendTime(timestamp: TimeInterval) ->String {
        var lastestMessageTime = ""
        var timeInterval = timestamp
        if timeInterval > 140000000000 {
            timeInterval = timeInterval / 1000
        }
        let formatter = DateFormatter.init()
        formatter.dateFormat = "YYYY-MM-dd"
        lastestMessageTime = formatter.string(from: Date.init(timeIntervalSince1970: TimeInterval(timeInterval)))
        return lastestMessageTime
    }
    
    // 计算图片的显示尺寸
    class func imageSize(actualSize: CGSize) ->CGSize {
        var height = ChatCell.Frame.imageHeight
        var width  = actualSize.width * height / actualSize.height
        if width > ChatCell.Frame.contentLayoutWidth {
            width = ChatCell.Frame.contentLayoutWidth
            height = width * actualSize.height / actualSize.width
        }
        return CGSize.init(width: width, height: height)
    }
}
