//
//  EaseMobMessageManager.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/20.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation

class EaseMobMessageManager: NSObject {
    
    override init() {
        super.init()
        
    }
    
    // 注册环信回调回调
    func emRegisterDelegate() {
        EMClient.shared().chatManager.add(self, delegateQueue: nil)
        EMClient.shared().contactManager.add(self, delegateQueue: nil)
    }
}

extension EaseMobMessageManager: EMChatManagerDelegate {
    
    func conversationListDidUpdate(_ aConversationList: [Any]!) {
        PrintLog("会话列表发生变化： \(aConversationList)")
        NotificationCenter.default.post(name: NotificationName.EaseMob.ConversationListChange, object: nil)
    }
    
    func messagesDidReceive(_ aMessages: [Any]!) {
        PrintLog("收到消息：\(aMessages)")
        NotificationCenter.default.post(name: NotificationName.EaseMob.ReceivedNewMessage, object: aMessages)
    }
}

extension EaseMobMessageManager: EMContactManagerDelegate {
    
    func friendRequestDidReceive(fromUser aUsername: String!, message aMessage: String!) {
        AddFriendsModel.inster(with: aUsername) {
            NotificationCenter.default.post(name: NotificationName.EaseMob.addFriend, object: aUsername)
        }
//        NoticesCenter.alert(message: "收到 \(aUsername ?? "") 的好友申请", cancleTitle: "拒绝", okTitle: "同意", callBackCancle: {
//
//        }) {
//            if let error = EMClient.shared()?.contactManager.acceptInvitation(forUsername: aUsername) {
//                PrintLog("同意 \(aUsername) 的好友申请 失败！")
//            }else {
//                PrintLog("已同意 \(aUsername) 的好友申请！")
//            }
//        }
    }
    
    func friendRequestDidApprove(byUser aUsername: String!) {
//        NoticesCenter.alert(message: "\(aUsername) 已接受我的好友邀请")
        PrintLog("\(aUsername ?? "") 已接受我的好友邀请")
    }
    
    func friendshipDidRemove(byUser aUsername: String!) {
//        NoticesCenter.alert(message: "\(aUsername) 已解除与我的好友关系")
        PrintLog("\(aUsername ?? "") 已解除与我的好友关系")
    }

}
