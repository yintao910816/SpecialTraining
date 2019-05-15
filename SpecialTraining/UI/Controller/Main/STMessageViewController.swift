//
//  STMessageViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/16.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxDataSources

class STMessageViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var headerView: MessageHeaderFilesOwner!
    
    private var viewModel: MessageViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if UserAccountServer.share.loginUser.member.uid == 0 {
            STHelper.presentLogin()
        }
    }
    
    override func setupUI() {
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }

        headerView = MessageHeaderFilesOwner.init()
        tableView.tableHeaderView = headerView.contentView
        
        tableView.rowHeight = 86
        
        tableView.register(UINib.init(nibName: "MessageListCell", bundle: Bundle.main), forCellReuseIdentifier: "MessageListCellID")
    }
    
    override func rxBind() {

        headerView.contactsOutlet.rx.tap.asDriver()
            .drive(onNext: { [unowned self] model in
                self.performSegue(withIdentifier: "contactsSegue", sender: model)
            })
            .disposed(by: disposeBag)

        viewModel = MessageViewModel()
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "MessageListCellID", cellType: MessageListCell.self)) { (row, model, cell) in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ChatListModel.self)
            .asDriver()
            .drive(onNext: { [unowned self] model in
                self.performSegue(withIdentifier: "chatRoomSegue", sender: model)
            })
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatRoomSegue" {
            let chatRoomVC = segue.destination as! STChatRoomViewController
            chatRoomVC.conversation = (sender as! ChatListModel).conversation
        }
    }

}
