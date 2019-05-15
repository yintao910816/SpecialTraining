//
//  Conversation.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/19.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation

class ChatListModel: ChatMessageProtocol {
    
    var userIcon: String    = ""
    var userName: String    = ""
    var textContent: String = ""
    var time: String        = ""
    
    var conversation: EMConversation!
    
    var textContentLayout: YYTextLayout!

    class func creatMessage(conversation: EMConversation) ->ChatListModel {
        let m = ChatListModel()
        m.conversation = conversation
        
        m.userName = conversation.conversationId
        if conversation.latestMessage != nil {
            m.textContent = m.chatList(content: conversation.latestMessage)
            m.textContentLayout = configAttr(model: m)
            m.time = ConversationUtil.latestMessageTime(conversationModel: conversation)
        }
        return m
    }

}

extension ChatListModel: EmojiHander {
    
    fileprivate class func configAttr(model: ChatListModel) ->YYTextLayout {
        let contentAttr = model.transform(model.textContent, 3)
        contentAttr.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: sr_fontName, size: 14)!, range: NSMakeRange(0, contentAttr.length))
        contentAttr.addAttribute(NSAttributedString.Key.foregroundColor, value: RGB(68, 68, 68), range: NSMakeRange(0, contentAttr.length))
        return YYTextLayout.init(containerSize: CGSize.init(width: MessageListCell.Frame.textContentPrepareWidth, height: CGFloat(MAXFLOAT)), text: contentAttr)!
    }

}

class ChatModel {
    
    var uid: String = ""
    
    var nickName: String = ""
    
    var iconStr: String  = ""
    
    var messageTime: String = ""
    
    var conversation: EMConversation!
    
    var message: EMMessage!
    
    var messageType = MessageBodyType.text
    
    // 消息是否来自自己发送
    var isMyselfSend: Bool = false
    
    var cellHeight: CGFloat = 0.0
    
    // 设置用户信息
    class func setUser(userInfo: UserInfoModel, chats: [ChatModel]) ->[ChatModel] {
        let myInfo = STHelper.share.loginUser!
        for chat in chats {
            // 自己
            if chat.message.from == "\(myInfo.uid)" {
                chat.isMyselfSend = true
                chat.uid = "\(myInfo.uid)"
                chat.nickName = myInfo.nickname
                chat.iconStr  = myInfo.headimgurl
            }else {
                chat.isMyselfSend = false
                chat.uid = "\(userInfo.uid)"
                chat.nickName = userInfo.nickname
                chat.iconStr  = userInfo.headimgurl
            }
        }
        
        return chats
    }
    
    class func setUser(chats: [ChatModel]) ->[ChatModel] {
        let myInfo = UserAccountServer.share.loginUser
        for chat in chats {
            // 自己
            if chat.message.from == "\(myInfo.member.mob)" {
                chat.isMyselfSend = true
//                chat.uid = "\(myInfo.uid)"
//                chat.nickName = myInfo.nickname
//                chat.iconStr  = myInfo.headimgurl
            }else {
                chat.isMyselfSend = false
//                chat.uid = "\(userInfo.uid)"
//                chat.nickName = userInfo.nickname
//                chat.iconStr  = userInfo.headimgurl
            }
        }
        
        return chats
    }
    
    class func config(data conversation: EMConversation, callBack: @escaping ([ChatModel]) ->Void) {
        
        conversation.loadMessagesStart(fromId: "", count: 20, searchDirection: .init(0)) { (messages, error) in
            
            guard let tempMessages = messages as? [EMMessage] else {
                callBack([ChatModel]())
                return
            }
            var retDatas = [ChatModel]()
            for emgs in tempMessages {
                switch emgs.body.type {
                case EMMessageBodyType.init(1):
                    // 文本类型
                    retDatas.append(ChatTextModel.creatModel(emMes: emgs, conversation: conversation))
                case EMMessageBodyType.init(2):
                    // 图片类型
                    retDatas.append(ChatImageModel.creatModel(emMes: emgs, conversation: conversation))
//
//                case EMMessageBodyType.init(3):
//                    // 视频类型
//
//                case EMMessageBodyType.init(4):
//                    // 位置类型
//
                case EMMessageBodyType.init(5):
                    // 语音类型
                    retDatas.append(ChatVoiceModel.creatModel(emMes: emgs, conversation: conversation))
                    
//                case EMMessageBodyType.init(6):
//                    // 文件类型
//
//                case EMMessageBodyType.init(7):
//                    // 命令类型

                default:
                    break
                }
            }
            
            callBack(retDatas)
        }
    }
    
    class func appendModel(emMes: [EMMessage], conversation: EMConversation) ->[ChatModel] {
        var retData = [ChatModel]()
        for emg in emMes {
            switch emg.body.type {
            case EMMessageBodyType.init(1):
                // 文本类型
                retData.append(ChatTextModel.creatModel(emMes: emg, conversation: conversation))
            case EMMessageBodyType.init(2):
                // 图片类型
                retData.append(ChatImageModel.creatModel(emMes: emg, conversation: conversation))
                
                //
                //                case EMMessageBodyType.init(3):
                //                    // 视频类型
                //
                //                case EMMessageBodyType.init(4):
                //                    // 位置类型
                //
            case EMMessageBodyType.init(5):
                // 语音类型
                retData.append(ChatVoiceModel.creatModel(emMes: emg, conversation: conversation))
                //
                //                case EMMessageBodyType.init(6):
                //                    // 文件类型
                //
                //                case EMMessageBodyType.init(7):
                //                    // 命令类型
                
            default:
                break
            }
        }
        
        return retData
    }

}

extension ChatModel: EmojiHander {
    
    fileprivate class func configAttr(model: ChatTextModel) ->YYTextLayout {
        let contentAttr = model.transform(model.contentText, 3)
        contentAttr.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: sr_fontName, size: 14)!, range: NSMakeRange(0, contentAttr.length))
        contentAttr.addAttribute(NSAttributedString.Key.foregroundColor, value: RGB(68, 68, 68), range: NSMakeRange(0, contentAttr.length))
        return YYTextLayout.init(containerSize: CGSize.init(width: ChatCell.Frame.contentLayoutWidth, height: CGFloat(MAXFLOAT)), text: contentAttr)!
    }
    
    fileprivate class func cellHeight(textLayout: YYTextLayout) ->CGFloat {
        let textHeight = textLayout.textBoundingSize.height
        if textHeight <= ChatCell.Frame.textMinHeight {
            return ChatCell.Frame.iconHeight + ChatCell.Frame.otherHeight
        }
        
        return ChatCell.Frame.otherHeight + textHeight + ChatCell.Frame.content_v_margin * 2
    }
}

//MARK:
//MARK: 文本消息
class ChatTextModel: ChatModel {
    
    var textContentLayout: YYTextLayout!
    
    var contentText: String = ""
    
    class func creatModel(emMes: EMMessage, conversation: EMConversation) ->ChatTextModel {
        let m = ChatTextModel()
        m.conversation = conversation
        m.message = emMes
        m.messageType = .text
        m.contentText = (emMes.body as! EMTextMessageBody).text
        
        let textLayout = configAttr(model: m)
        
        m.textContentLayout = textLayout
        
        m.messageTime = ConversationUtil.messageSendTime(timestamp: TimeInterval(emMes.timestamp))
        
        m.cellHeight = cellHeight(textLayout: textLayout)
        
        return m
    }
}

//MARK:
//MARK: 图片消息
class ChatImageModel: ChatModel {
    
    var imageMessageBody: EMImageMessageBody!
    
    // 缩略图的本地路径
    var thumbnailLocalPath: String?
    // 附件的本地路径
    var localPath: String?
    // 缩略图宽度
    var width: CGFloat = 0
    // 缩略图高度
    var height: CGFloat = 0
    
    var image: UIImage? = nil

    class func creatModel(emMes: EMMessage, conversation: EMConversation) ->ChatImageModel {
        let imageMessageBody = (emMes.body as! EMImageMessageBody)
        
        let m = ChatImageModel()
        m.conversation = conversation
        m.message = emMes
        m.messageType = .image
        m.messageTime = ConversationUtil.messageSendTime(timestamp: TimeInterval(emMes.timestamp))
        
        let imageSize = ConversationUtil.imageSize(actualSize: imageMessageBody.size)
        m.width = imageSize.width
        m.height = imageSize.height
        
        m.setImage(emsg: emMes)
        
        let ch = m.height + ChatCell.Frame.content_v_margin * 2
        if ch <= ChatCell.Frame.iconHeight {
            m.cellHeight = ChatCell.Frame.iconHeight + ChatCell.Frame.otherHeight
        }else {
            m.cellHeight = ChatCell.Frame.otherHeight + ChatCell.Frame.content_v_margin * 2 + m.height
        }
        return m
    }
    
    func setImage(emsg: EMMessage) {
        let imageMessageBody = (emsg.body as! EMImageMessageBody)
        thumbnailLocalPath = imageMessageBody.thumbnailLocalPath
        localPath = imageMessageBody.localPath
        let imageFilePath = ((thumbnailLocalPath != nil) && (thumbnailLocalPath?.count ?? 0) > 0) ? thumbnailLocalPath! : localPath
        if imageFilePath != nil {
            image = UIImage.init(contentsOfFile: imageFilePath!)
        }
    }
}


import RxSwift
//MARK:
//MARK: 语音消息
class ChatVoiceModel: ChatModel {

    private let disposeBag = DisposeBag()

    var audoMessageBody: EMVoiceMessageBody!

    var duration: Int = 0
    
    var voiceLocalPath: String = ""
    var voiceRemotePath: String = ""
    
    var isPlaying: Bool = false
    
    class func creatModel(emMes: EMMessage, conversation: EMConversation) ->ChatVoiceModel {
        let audioMessageBody = (emMes.body as! EMVoiceMessageBody)
        
        let m = ChatVoiceModel()
        m.conversation = conversation
        m.message = emMes
        m.messageType = .voice
        m.voiceLocalPath = audioMessageBody.localPath
        m.voiceRemotePath = audioMessageBody.remotePath
        m.messageTime = ConversationUtil.messageSendTime(timestamp: TimeInterval(emMes.timestamp))
        m.duration  = Int(audioMessageBody.duration)

        m.cellHeight = ChatCell.Frame.audoCellHeight
        return m
    }
    
}

protocol ChatMessageProtocol {
    
    func chatList(content amessage: EMMessage) ->String
}

extension ChatMessageProtocol {
   
    func chatList(content amessage: EMMessage) ->String {
        switch amessage.body.type {
        case EMMessageBodyType.init(1):
            // 文本类型
            return (amessage.body as! EMTextMessageBody).text
        case EMMessageBodyType.init(2):
            // 图片类型
            return "[图片]"
        case EMMessageBodyType.init(3):
            // 视频类型
            return "[视屏]"
        case EMMessageBodyType.init(4):
            // 位置类型
            return "[位置]"
        case EMMessageBodyType.init(5):
            // 语音类型
            return "[语音]"
        case EMMessageBodyType.init(6):
            // 文件类型
            return "[文件]"
        case EMMessageBodyType.init(7):
            // 命令类型
            return "[命令]"
        default:
            return ""
        }
    }
}

//MARK
//MARK: 消息类型
enum MessageBodyType {
    case text
    case image
    case video
    case location
    case voice
    case file
    case cmd
}
