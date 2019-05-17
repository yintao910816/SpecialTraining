//
//  STContactsViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/5/15.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STContactsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: ContactsViewModel!
    
    override func setupUI() {
        
        tableView.rowHeight = 50
        tableView.register(UINib.init(nibName: "NoticeAndApplyCell", bundle: Bundle.main),
                           forCellReuseIdentifier: "NoticeAndApplyCellID")
    }
    
    override func rxBind() {
        
        addBarItem(title: "添加")
            .drive(onNext: { [unowned self] in
                self.performSegue(withIdentifier: "addFriendsSegue", sender: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel = ContactsViewModel()
        
        viewModel.listDataSource.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
//        viewModel.listDataSource.asDriver()
//            .drive(tableView.rx.items(cellIdentifier: "NoticeAndApplyCellID", cellType: NoticeAndApplyCell.self)) { _, model, cell in
//                cell.model = model
//            }
//            .disposed(by: disposeBag)
        
//        tableView.rx.modelSelected(ContactsModel.self)
//            .asDriver()
//            .drive(onNext: { [unowned self] model in
//                if model.userName.count > 0 {
//                    self.viewModel.creatConversationSubject.onNext(model)
//                }else {
//                    self.performSegue(withIdentifier: "applysSegue", sender: nil)
//                }
//            })
//            .disposed(by: disposeBag)
    }
}

extension STContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = viewModel.listDataSource.value[indexPath.section][indexPath.row]
        if contact.userName.count > 0 {
            self.viewModel.creatConversationSubject.onNext(contact)
        }else {
            self.performSegue(withIdentifier: "applysSegue", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        let view = UIView()
        view.backgroundColor = RGB(245, 245, 245)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 12
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.deleteContactSubject.onNext(indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 0
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除好友"
    }
}

extension STContactsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listDataSource.value[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.listDataSource.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeAndApplyCellID") as! NoticeAndApplyCell
        cell.model = viewModel.listDataSource.value[indexPath.section][indexPath.row]
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return nil
    }
}
