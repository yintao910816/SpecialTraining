//
//  STChatRoomViewController.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/20.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxDataSources

class STChatRoomViewController: BaseViewController {

    @IBOutlet weak var tableView: BaseTB!
    @IBOutlet weak var inputOutlet: CommentTextView!

    private var keyboardManager = KeyboardManager()
    private var photoManager: ImagePickerManager!
    
    // 当前聊天室会话
    var conversation: EMConversation!
    
    private var viewModel: ChatRoomViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        keyboardManager.registerNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if navigationController?.viewControllers.contains(self) == false {
            inputOutlet.delegate = nil
        }
        
        keyboardManager.removeNotification()
    }
    
    override func setupUI() {
        photoManager = ImagePickerManager.init(viewController: self)
        photoManager.pickerDelegate = self
        
        inputOutlet.delegate    = self

        inputOutlet.placeholder = "请输入聊天内容"
        
        tableView.register(ChatCell.self, forCellReuseIdentifier: "ChatCellID")
    }
    
    override func rxBind() {
        viewModel = ChatRoomViewModel.init(conversation: conversation)
        
        viewModel.navTitle.asDriver()
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "ChatCellID", cellType: ChatCell.self)) { (row, element, cell) in
                cell.model = element
            }
            .disposed(by: disposeBag)
        
        viewModel.scrollTab.subscribe(onNext: { [weak self] _ in
            guard let tb = self?.tableView, let datas = self?.viewModel.datasource else {
                return
            }

            let indexPath = IndexPath.init(item: datas.value.count - 1, section: 0)
            tb.scrollToRow(at: indexPath, at: .bottom, animated: false)
        })
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        
        tableView.scrollToBottom()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        keyboardManager.move(coverView: inputOutlet, moveView: inputOutlet)
    }
    
    override func prepare(parameters: [String : Any]?) {
        conversation = (parameters!["conversation"] as! EMConversation)
    }
}

extension STChatRoomViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = viewModel.datasource.value[indexPath.row]
        return model.cellHeight
    }
}

extension STChatRoomViewController: CommentTextViewDelegate {
    
    func mediaSelected(idx: Int) {
        photoManager.openPickerSignal.onNext((MediaType.photoLibrary, false))
    }
    
    func tv_textViewShouldBeginEditing(_ textView: CommentTextView) -> Bool {
        return true
    }
    
    func tv_textViewDidEndEditing(_ textView: CommentTextView) {
        
    }
    
    func submitComment(_ content: String?) {
        inputOutlet.placeholder = "请输入聊天内容"
        viewModel.sendMessage.onNext(content)
    }
    
    func recordFinish(with data: Data, duration: Int) {
        viewModel.sendAudio.onNext((data, duration))
    }
}

extension STChatRoomViewController: ImagePickerDelegate {
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage?, editedImage: UIImage?) {
        if let i = image {
            viewModel.sendImage.onNext(i)
        }
    }
}
