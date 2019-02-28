//
//  STNoticeSettingViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/1.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit
import RxDataSources

class STNoticeSettingViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    private var viewModel: NoticeSettingViewModel!
    
    override func setupUI() {
        navigationItem.title = "消息提醒设置"
        
        tableView.rowHeight = 50
        tableView.register(UINib.init(nibName: "NoticeSettingCell", bundle: Bundle.main),
                           forCellReuseIdentifier: "NoticeSettingCellID")
    }
    
    override func rxBind() {
        viewModel = NoticeSettingViewModel()
        
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<Int, NoticeSettingModel>>.init(configureCell: { _, tb, indexPath, model in
            let cell = tb.dequeueReusableCell(withIdentifier: "NoticeSettingCellID") as! NoticeSettingCell
            cell.model = model
            return cell
        })
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asDriver()
            .drive(viewModel.cellDidSelected)
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
}

extension STNoticeSettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lable = UILabel()
        lable.textColor = RGB(220, 220, 220)
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.text = "   请设置您的消息提醒方式"
        return lable
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

}
