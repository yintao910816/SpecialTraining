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
    
    public var datasource = Variable([ChatListModel]())
    public var deleteConversationSubject = PublishSubject<IndexPath>()
    
    override init() {
        super.init()

        deleteConversationSubject
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] indexPath in
                let model = self.datasource.value[indexPath.row]
                EMClient.shared()?.chatManager.deleteConversation(model.conversation.conversationId, isDeleteMessages: true, completion: { (msg, error) in
                    let tempData = self.datasource.value.filter{ $0.conversation.conversationId != model.conversation.conversationId }
                    self.datasource.value = tempData
                })
            })
            .disposed(by: disposeBag)

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
