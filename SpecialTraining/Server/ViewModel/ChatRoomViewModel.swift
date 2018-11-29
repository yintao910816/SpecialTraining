//
//  ChatRoomViewModel.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/20.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ChatRoomViewModel: RefreshVM<ChatModel> {
    
    private var conversation: EMConversation!
    
    private var userInfoModel: UserInfoModel!
    
    // 发送文字类消息
    public let sendMessage = PublishSubject<String?>()
    // 发送图片消息
    public let sendImage = PublishSubject<UIImage>()
    // 发送语音消息
    public let sendAudio = PublishSubject<(Data, Int)>()

    public let scrollTab = PublishSubject<Bool>()
    
    public let navTitle = Variable("")
    
    private var lastPlayVoiceModel: ChatVoiceModel?
    
    init(conversation: EMConversation) {
        super.init()
        self.conversation = conversation
        
        ChatModel.config(data: conversation) { [weak self] datas in
            self?.datasource.value = datas
        }
        
        NotificationCenter.default.rx.notification(NotificationName.EaseMob.ReceivedNewMessage)
            .subscribe(onNext: { [weak self] no in
                self?.dealNewMessage(no: no)
            })
            .disposed(by: disposeBag)
        
        sendMessage
            .filter{ ($0?.count ?? 0) > 0 }
            .subscribe(onNext: { [unowned self] content in
                self.sendMessage(content: content!)
            })
            .disposed(by: disposeBag)
        
        sendImage
            .subscribe(onNext: { [unowned self] content in
                self.sendImage(content: content)
            })
            .disposed(by: disposeBag)
        
        sendAudio
            .subscribe(onNext: { [unowned self] content in
                self.sendAudio(content: content)
            })
            .disposed(by: disposeBag)

        // 首次加载聊天界面数据
        Observable.combineLatest(loadChatContent(), findUser(uid: conversation.conversationId))
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [weak self] (chatModels, userInfo) in
                self?.hud.noticeHidden()
                self?.userInfoModel = userInfo
                self?.navTitle.value = userInfo.nickname
                self?.datasource.value = ChatModel.setUser(userInfo: userInfo, chats: chatModels)
                self?.scrollTab.onNext(true)
            }, onError: { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.AudioPlayState.AudioPlayStart, object: nil)
            .subscribe(onNext: { [weak self] no in
                if let lastPlay = self?.lastPlayVoiceModel {
                    lastPlay.isPlaying = false
                    DPAudioPlayer.sharedInstance()?.stopPlaying()
                    self?.reloadTB()
                }
                
                let audioModel = no.object as! ChatVoiceModel

                if FileManager.default.fileExists(atPath: audioModel.voiceLocalPath),
                    let data = FileManager.default.contents(atPath: audioModel.voiceLocalPath){
                    DPAudioPlayer.sharedInstance()?.startPlay(with: data)
                    self?.lastPlayVoiceModel = audioModel
                }else {
                    self?.lastPlayVoiceModel = nil
                    self?.reloadTB()
                    self?.hud.failureHidden("语音文件解码失败")
                }

            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.AudioPlayState.AudioPlayStop, object: nil)
            .subscribe(onNext: { [weak self] no in
                DPAudioPlayer.sharedInstance()?.stopPlaying()
                self?.lastPlayVoiceModel = nil
            })
            .disposed(by: disposeBag)

        DPAudioPlayer.sharedInstance()?.playComplete = { [weak self] in
            self?.lastPlayVoiceModel?.isPlaying = false
            self?.reloadTB()
            
            self?.lastPlayVoiceModel = nil
        }
    }
    
    // 刷新数据
    private func reloadTB() {
        let tempData = datasource.value
        self.datasource.value = tempData
    }
    
    // 加载聊天数据
    private func loadChatContent() ->Observable<[ChatModel]>{
        return Observable.create({ [unowned self] obser -> Disposable in
            ChatModel.config(data: self.conversation, callBack: { datas in
                obser.onNext(datas)
                obser.onCompleted()
            })
            return Disposables.create { }
        })
    }
    
    // 加载对方用户信息
    private func findUser(uid: String) ->Observable<UserInfoModel> {
        return STHelper.share.findUser(uid: uid)
    }
    
    // 处理当前聊天的最新消息
    private func dealNewMessage(no: Notification) {
        guard let eMegs = no.object as? [EMMessage]  else {
            return
        }
        
        var currentConversationMsgs = [EMMessage]()
        for msg in eMegs {
            if msg.conversationId == conversation.conversationId {
                currentConversationMsgs.append(msg)
            }
        }
        
        if currentConversationMsgs.count > 0 { dealMessage(mesgs: currentConversationMsgs) }

    }
    
    // 构造文本消息
    private func sendMessage(content: String) {
        let body = EMTextMessageBody.init(text: content)
        PrintLog(userDefault.uid)
        PrintLog(conversation.conversationId!)

        let amessage = EMMessage.init(conversationID: conversation.conversationId,
                                      from: userDefault.uid,
                                      to: conversation.conversationId,
                                      body: body,
                                      ext: ["em_apns_ext": ["em_push_title": content]])!
        sendMessage(amessage: amessage)
    }
    
    // 构造语音消息
    private func sendAudio(content: (Data, Int)) {
        let body = EMVoiceMessageBody.init(data: content.0, displayName: "\(userDefault.uid)_\(content.1)")
        body?.duration = Int32(content.1)
        PrintLog(userDefault.uid)
        PrintLog(conversation.conversationId!)
        
        let amessage = EMMessage.init(conversationID: conversation.conversationId,
                                      from: userDefault.uid,
                                      to: conversation.conversationId,
                                      body: body,
                                      ext: ["em_apns_ext": ["em_push_title": "语音消息"]])!
        sendMessage(amessage: amessage)
    }
    
    // 构造图片消息
    private func sendImage(content: UIImage) {
        guard let data = content.jpegData(compressionQuality: 0.2) else {
            hud.failureHidden("图片发送失败")
            return
        }
        let body = EMImageMessageBody.init(data: data, displayName: "\(Date().milliStamp).jpg")
        let amessage = EMMessage.init(conversationID: conversation.conversationId,
                                      from: userDefault.uid,
                                      to: conversation.conversationId,
                                      body: body,
                                      ext: ["em_apns_ext": ["em_push_title": "图片消息"]])!
        
        sendMessage(amessage: amessage)
    }
    
    // 发送消息
    private func sendMessage(amessage: EMMessage) {
        EMClient.shared()?.chatManager.send(amessage, progress: nil, completion: { [weak self] (message, error) in
            if error == nil, let msg = message{
                self?.dealMessage(mesgs: [msg])
            }else {
                self?.hud.failureHidden(error?.errorDescription)
            }
        })
    }
    
    // 对消息进行处理
    private func dealMessage(mesgs: [EMMessage]) {
        var tempDatas = datasource.value
        
        var appendDatas = ChatModel.appendModel(emMes: mesgs, conversation: conversation)
        appendDatas = ChatModel.setUser(userInfo: userInfoModel, chats: appendDatas)
        tempDatas.append(contentsOf: appendDatas)
        
        datasource.value = tempDatas
        
        scrollTab.onNext(true)
    }
    
}
