//
//  ContactsViewModel.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/15.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class ContactsViewModel: BaseViewModel, VMNavigation {
    
    public var listDataSource = Variable([[ContactsModel]]())
    public let creatConversationSubject = PublishSubject<ContactsModel>()
    public let deleteContactSubject = PublishSubject<IndexPath>()

    override init() {
        super.init()
        
        EMClient.shared()?.contactManager.getContactsFromServer(completion: { [weak self] (data, error) in
            var datas = [[ContactsModel]]()
            
            let normalModel = ContactsModel()
            normalModel.title = "申请与通知"
            datas.append([normalModel])
            
            if let contacts = data as? [String] {
                datas.append(contentsOf: [ContactsModel.creat(with: contacts)])
            }
            self?.listDataSource.value = datas
        })
        
        creatConversationSubject
            .subscribe(onNext: { model in
                let conversation = EMClient.shared()!.chatManager.getConversation(model.userName,
                                                                                  type: EMConversationType.init(0),
                                                                                  createIfNotExist: true)
                ContactsViewModel.sbPush("STMessage", "chatRoomCtrl", parameters: ["conversation": conversation!])
            })
            .disposed(by: disposeBag)
        
        deleteContactSubject
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [weak self] indexPath in
                guard let strongSelf = self else { return }
                var data = strongSelf.listDataSource.value
                var contacts = data[1]
                let contact = contacts[indexPath.row]
                EMClient.shared()?.contactManager.deleteContact(contact.userName,
                                                                isDeleteConversation: true,
                                                                completion:
                    { (msg, error) in
                        if error == nil {
                            contacts = contacts.filter{ $0.userName != contact.userName }
                            data[1] = contacts
                            strongSelf.listDataSource.value = data
                            strongSelf.hud.noticeHidden()
                        }else {
                            strongSelf.hud.failureHidden(error?.errorDescription)
                        }
                })
            })
            .disposed(by: disposeBag)
    }
}
