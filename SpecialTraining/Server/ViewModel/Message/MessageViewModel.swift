//
//  MessageViewModel.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/19.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift

class MessageViewModel: BaseViewModel {
    
    var datasource = Variable([ChatListModel]())
    
    override init() {
        super.init()

        NotificationCenter.default.rx.notification(NotificationName.EaseMob.ConversationListChange)
            .subscribe(onNext: { [unowned self] _ in
                self.dealChatListData()
            })
            .disposed(by: disposeBag)
        
        dealChatListData()
    }
    
    private func dealChatListData() {
        if let conversations = EMClient.shared()?.chatManager.getAllConversations() as? [EMConversation] {
            var chatListModes = [ChatListModel]()
            for conversation in conversations {
                chatListModes.append(ChatListModel.creatMessage(conversation: conversation))
            }
            datasource.value = chatListModes
        }
    }
}
